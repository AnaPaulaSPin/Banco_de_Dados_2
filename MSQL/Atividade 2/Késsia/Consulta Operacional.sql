-- O Aluno quer saber as suas notas e de qual disciplina foi
Select d.matricula As Discente, r.nota, dis.nome As Disciplina
From ((((discente d join resultado r on r.idDiscente = d.idDiscente) 
join aplicacao ap on r.idAplicacao = ap.idAplicacao) 
join avaliacao av on ap.idAvaliacao = av.idAvaliacao) 
join disciplina dis on av.idDisciplina = dis.idDisciplina)
Where d.matricula = 2026001;

-- O aluno quer ver em que disciplinas está matriculado e o docente que adiministra 
Select d.matricula As Discente, dis.nome As Disciplina, a.nome As Docente
From (((((discente d join discente_turma dt on dt.idDiscente = d.idDiscente) 
join turma t on dt.idTurma = t.idTurma) 
join disciplina dis on t.idDisciplina = dis.idDisciplina)
join docente doc on t.idDocente = doc.idDocente)
join usuario a on a.idUsuario = doc.idUsuario)
Where d.matricula = 2026001;