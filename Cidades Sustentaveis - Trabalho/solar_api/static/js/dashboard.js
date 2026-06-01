document.addEventListener("DOMContentLoaded", () => {
    carregarCidades();

    document.getElementById("cidadeSelect").addEventListener("change", (e) => {
        const idCidade = e.target.value;
        if (idCidade) {
            carregarResumoCidade(idCidade);
            carregarUnidades(idCidade); // atualiza tabela ao trocar cidade
        }
    });
});

// 1. Busca todas as cidades da API e popula o <select>
async function carregarCidades() {
    try {
        const response = await fetch('/cidades');
        const cidades = await response.json();
        
        const select = document.getElementById("cidadeSelect");
        select.innerHTML = '';

        if (cidades.length === 0) {
            select.innerHTML = '<option value="">Nenhuma cidade cadastrada</option>';
            return;
        }

        cidades.forEach(cidade => {
            const option = document.createElement("option");
            option.value = cidade.idCidade;
            option.textContent = cidade.nome;
            select.appendChild(option);
        });

        // Carrega automaticamente os dados da primeira cidade da lista
        carregarResumoCidade(cidades[0].idCidade);
        carregarUnidades(cidades[0].idCidade); // passa o id da cidade
    } catch (error) {
        console.error("Erro ao carregar cidades:", error);
        alert("Erro de conexão com a API ao buscar cidades.");
    }
}

// 2. Busca os dados consolidados de medição da cidade
async function carregarResumoCidade(idCidade) {
    try {
        const response = await fetch(`/medicoes/resumo/cidade/${idCidade}`);
        
        if (!response.ok) {
            zerarPainel();
            return;
        }

        const dados = await response.json();

        document.getElementById("kpi-unidades").textContent = dados.total_unidades || 0;
        document.getElementById("kpi-gerada").innerHTML = `${dados.energia_gerada_kwh} <small>kWh</small>`;
        
        const economiaFormatada = parseFloat(dados.economia_total_reais).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        document.getElementById("kpi-economia").textContent = economiaFormatada;
        
        document.getElementById("kpi-co2").innerHTML = `${dados.co2_evitado_kg} <small>kg</small>`;

    } catch (error) {
        console.error("Erro ao carregar resumo da cidade:", error);
    }
}

// 3. Busca e lista as unidades da cidade selecionada na tabela
async function carregarUnidades(idCidade) {
    try {
        const response = await fetch(`/unidades/cidade/${idCidade}`);
        const unidades = await response.json();
        
        const tbody = document.querySelector("#unidadesTable tbody");
        tbody.innerHTML = '';

        unidades.forEach(u => {
            const tr = document.createElement("tr");
            tr.innerHTML = `
                <td>${u.nomeResponsavel}</td>
                <td><span style="font-size:0.85em; background:#eee; padding:3px 8px; border-radius:12px;">${u.tipoUnidade}</span></td>
                <td>${u.bairro}</td>
                <td>${u.cidade}</td>
            `;
            tbody.appendChild(tr);
        });
    } catch (error) {
        console.error("Erro ao carregar unidades:", error);
    }
}

// Zera o painel se a cidade não tiver medições
function zerarPainel() {
    document.getElementById("kpi-unidades").textContent = "0";
    document.getElementById("kpi-gerada").innerHTML = `0 <small>kWh</small>`;
    document.getElementById("kpi-economia").textContent = "R$ 0,00";
    document.getElementById("kpi-co2").innerHTML = `0 <small>kg</small>`;
}