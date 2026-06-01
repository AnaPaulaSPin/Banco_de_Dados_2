# routes/medicoes.py
# Endpoints para MedicaoEnergia — o coração dos dados do sistema.
# Rotas:
#   GET /medicoes/sistema/<id>        — medições de um sistema específico
#   GET /medicoes/unidade/<id>        — medições de uma unidade consumidora
#   GET /medicoes/resumo/cidade/<id>  — resumo agregado por cidade
#   POST /medicoes                    — registra uma nova medição

from flask import Blueprint, jsonify, request
from database import get_connection

medicoes_bp = Blueprint('medicoes', __name__)


# ─────────────────────────────────────────────
# GET /medicoes/sistema/<id_sistema>
# Lista todas as medições de um sistema de painéis.
# ─────────────────────────────────────────────
@medicoes_bp.route('/medicoes/sistema/<int:id_sistema>', methods=['GET'])
def medicoes_por_sistema(id_sistema):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT *
                FROM MedicaoEnergia
                WHERE idSistemaPainel = %s
                ORDER BY dataMedicao DESC
            """, (id_sistema,))
            medicoes = cursor.fetchall()
        return jsonify(medicoes), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /medicoes/unidade/<id_unidade>
# Busca medições de uma unidade consumidora.
# Precisa navegar: UnidadeConsumidora → Contrato → SistemaPainel → MedicaoEnergia
# ─────────────────────────────────────────────
@medicoes_bp.route('/medicoes/unidade/<int:id_unidade>', methods=['GET'])
def medicoes_por_unidade(id_unidade):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    uc.nomeResponsavel,
                    me.dataMedicao,
                    me.energiaGeradaKwh,
                    me.energiaConsumidaKwh,
                    me.energiaExcedenteKwh,
                    me.economiaEstimada,
                    me.co2EvitarKg
                FROM UnidadeConsumidora uc
                JOIN Contrato      c  ON uc.idUnidadeConsumidora = c.idUnidadeConsumidora
                JOIN SistemaPainel sp ON c.idSistemaPainel        = sp.idSistemaPainel
                JOIN MedicaoEnergia me ON sp.idSistemaPainel      = me.idSistemaPainel
                WHERE uc.idUnidadeConsumidora = %s
                ORDER BY me.dataMedicao DESC
            """, (id_unidade,))
            medicoes = cursor.fetchall()
        return jsonify(medicoes), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# GET /medicoes/resumo/cidade/<id_cidade>
# Resumo energético total de uma cidade.
#
# CORREÇÃO: total_unidades agora conta TODAS as unidades da cidade
# (independente de terem contrato ou medição), usando subquery separada.
# Os dados energéticos continuam agregando só quem tem medições.
# ─────────────────────────────────────────────
@medicoes_bp.route('/medicoes/resumo/cidade/<int:id_cidade>', methods=['GET'])
def resumo_por_cidade(id_cidade):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    ci.nome                                        AS cidade,

                    -- Conta TODAS as unidades da cidade, com ou sem contrato/medição
                    (
                        SELECT COUNT(*)
                        FROM UnidadeConsumidora uc2
                        JOIN Bairro b2 ON uc2.idBairro = b2.idBairro
                        WHERE b2.idCidade = ci.idCidade
                    )                                              AS total_unidades,

                    COUNT(DISTINCT sp.idSistemaPainel)             AS total_sistemas,
                    ROUND(SUM(me.energiaGeradaKwh),   2)           AS energia_gerada_kwh,
                    ROUND(SUM(me.energiaConsumidaKwh),2)           AS energia_consumida_kwh,
                    ROUND(SUM(me.economiaEstimada),   2)           AS economia_total_reais,
                    ROUND(SUM(me.co2EvitarKg),        2)           AS co2_evitado_kg

                FROM Cidade ci
                JOIN Bairro             b  ON ci.idCidade              = b.idCidade
                JOIN UnidadeConsumidora uc ON b.idBairro               = uc.idBairro
                JOIN Contrato           c  ON uc.idUnidadeConsumidora  = c.idUnidadeConsumidora
                JOIN SistemaPainel      sp ON c.idSistemaPainel        = sp.idSistemaPainel
                JOIN MedicaoEnergia     me ON sp.idSistemaPainel       = me.idSistemaPainel
                WHERE ci.idCidade = %s
                GROUP BY ci.idCidade, ci.nome
            """, (id_cidade,))
            resumo = cursor.fetchone()
        if not resumo:
            return jsonify({'erro': 'Cidade não encontrada ou sem dados de medição'}), 404
        return jsonify(resumo), 200
    except Exception as e:
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()


# ─────────────────────────────────────────────
# POST /medicoes
# Registra uma nova medição de energia.
# ─────────────────────────────────────────────
@medicoes_bp.route('/medicoes', methods=['POST'])
def criar_medicao():
    dados = request.get_json()

    campos_obrigatorios = [
        'dataMedicao', 'energiaGeradaKwh', 'energiaConsumidaKwh',
        'energiaExcedenteKwh', 'economiaEstimada', 'co2EvitarKg', 'idSistemaPainel'
    ]
    for campo in campos_obrigatorios:
        if dados.get(campo) is None:
            return jsonify({'erro': f'Campo "{campo}" é obrigatório'}), 400

    campos_nao_negativos = [
        'energiaGeradaKwh', 'energiaConsumidaKwh',
        'energiaExcedenteKwh', 'economiaEstimada', 'co2EvitarKg'
    ]
    for campo in campos_nao_negativos:
        if dados[campo] < 0:
            return jsonify({'erro': f'Campo "{campo}" não pode ser negativo'}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO MedicaoEnergia
                    (dataMedicao, energiaGeradaKwh, energiaConsumidaKwh,
                     energiaExcedenteKwh, economiaEstimada, co2EvitarKg, idSistemaPainel)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                dados['dataMedicao'],
                dados['energiaGeradaKwh'],
                dados['energiaConsumidaKwh'],
                dados['energiaExcedenteKwh'],
                dados['economiaEstimada'],
                dados['co2EvitarKg'],
                dados['idSistemaPainel']
            ))
        conn.commit()
        return jsonify({'mensagem': 'Medição registrada com sucesso', 'id': cursor.lastrowid}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({'erro': str(e)}), 500
    finally:
        conn.close()