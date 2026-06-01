document.addEventListener("DOMContentLoaded", () => {
    carregarCidades();

    // Quando o usuário trocar a cidade, atualiza os dados
    document.getElementById("cidadeSelect").addEventListener("change", (e) => {
        const idCidade = e.target.value;
        if (idCidade) {
            carregarResumoCidade(idCidade);
        }
    });
});

// 1. Busca todas as cidades da API e popula o <select>
async function carregarCidades() {
    try {
        const response = await fetch('/cidades');
        const cidades = await response.json();
        
        const select = document.getElementById("cidadeSelect");
        select.innerHTML = ''; // Limpa as opções padrão

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
        carregarUnidades();

    } catch (error) {
        console.error("Erro ao carregar cidades:", error);
        alert("Erro de conexão com a API ao buscar cidades.");
    }
}

// 2. Busca os dados matemáticos consolidados de medição da cidade
async function carregarResumoCidade(idCidade) {
    try {
        const response = await fetch(`/medicoes/resumo/cidade/${idCidade}`);
        
        if (!response.ok) {
            // Se a API retornar 404 (Sem dados), zeramos o painel
            zerarPainel();
            return;
        }

        const dados = await response.json();

        // Atualiza o DOM (HTML) com os dados recebidos
        document.getElementById("kpi-unidades").textContent = dados.total_unidades || 0;
        document.getElementById("kpi-gerada").innerHTML = `${dados.energia_gerada_kwh} <small>kWh</small>`;
        
        // Formata o dinheiro para padrão BRL
        const economiaFormatada = parseFloat(dados.economia_total_reais).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        document.getElementById("kpi-economia").textContent = economiaFormatada;
        
        document.getElementById("kpi-co2").innerHTML = `${dados.co2_evitado_kg} <small>kg</small>`;

    } catch (error) {
        console.error("Erro ao carregar resumo da cidade:", error);
    }
}

// 3. Busca e lista todas as unidades na tabela (como apoio visual)
async function carregarUnidades() {
    try {
        const response = await fetch('/unidades');
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

// Função auxiliar para zerar o painel visualmente se uma cidade não tiver medições
function zerarPainel() {
    document.getElementById("kpi-unidades").textContent = "0";
    document.getElementById("kpi-gerada").innerHTML = `0 <small>kWh</small>`;
    document.getElementById("kpi-economia").textContent = "R$ 0,00";
    document.getElementById("kpi-co2").innerHTML = `0 <small>kg</small>`;
}