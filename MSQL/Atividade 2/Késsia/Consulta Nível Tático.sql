-- O Departamento quer Analisar a Quantidade de Alunos por Disciplina
Select dis.nome, Count(*) As Quantidade_Alunos
From (((discente d join discente_turma dt on dt.idDiscente = d.idDiscente) 
join turma t on dt.idTurma = t.idTurma) 
join disciplina dis on t.idDisciplina = dis.idDisciplina)
Group By dis.nome
Order By Quantidade_Alunos;

--  O Departamento quer saber quantos Alunos ingressaram no ano de 2026
Select Count(*) As Total_Ingresso_2026
from discente d
Where d.ingresso = 2026;
