document.addEventListener("DOMContentLoaded", async () => {
    // Verifica se está logado; se não, vai para o login
    const res = await fetch('/auth/me');
    if (!res.ok) {
        window.location.href = '/login';
        return;
    }

    const usuario = await res.json();
    document.getElementById('nav-nome').textContent   = usuario.nome;
    document.getElementById('nav-perfil').textContent = usuario.perfil;

    carregarCidades();

    document.getElementById("cidadeSelect").addEventListener("change", (e) => {
        const idCidade = e.target.value;
        if (idCidade) {
            carregarResumoCidade(idCidade);
            carregarUnidades(idCidade);
        }
    });
});

async function logout() {
    await fetch('/auth/logout', { method: 'POST' });
    window.location.href = '/login';
}

async function carregarCidades() {
    try {
        const response = await fetch('/cidades');
        const cidades  = await response.json();

        const select = document.getElementById("cidadeSelect");
        select.innerHTML = '';

        if (cidades.length === 0) {
            select.innerHTML = '<option value="">Nenhuma cidade cadastrada</option>';
            return;
        }

        cidades.forEach(cidade => {
            const option = document.createElement("option");
            option.value       = cidade.idCidade;
            option.textContent = cidade.nome;
            select.appendChild(option);
        });

        carregarResumoCidade(cidades[0].idCidade);
        carregarUnidades(cidades[0].idCidade);

    } catch (error) {
        console.error("Erro ao carregar cidades:", error);
        alert("Erro de conexão com a API ao buscar cidades.");
    }
}

async function carregarResumoCidade(idCidade) {
    try {
        const response = await fetch(`/medicoes/resumo/cidade/${idCidade}`);

        if (!response.ok) {
            zerarPainel();
            return;
        }

        const dados = await response.json();

        document.getElementById("kpi-unidades").textContent = dados.total_unidades || 0;
        document.getElementById("kpi-gerada").innerHTML     = `${dados.energia_gerada_kwh} <small>kWh</small>`;

        const economiaFormatada = parseFloat(dados.economia_total_reais)
            .toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        document.getElementById("kpi-economia").textContent = economiaFormatada;

        document.getElementById("kpi-co2").innerHTML = `${dados.co2_evitado_kg} <small>kg</small>`;

    } catch (error) {
        console.error("Erro ao carregar resumo da cidade:", error);
    }
}

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
                <td><span style="font-size:0.85em;background:#eee;padding:3px 8px;border-radius:12px;">${u.tipoUnidade}</span></td>
                <td>${u.bairro}</td>
                <td>${u.cidade}</td>
            `;
            tbody.appendChild(tr);
        });
    } catch (error) {
        console.error("Erro ao carregar unidades:", error);
    }
}

function zerarPainel() {
    document.getElementById("kpi-unidades").textContent = "0";
    document.getElementById("kpi-gerada").innerHTML     = `0 <small>kWh</small>`;
    document.getElementById("kpi-economia").textContent = "R$ 0,00";
    document.getElementById("kpi-co2").innerHTML        = `0 <small>kg</small>`;
}