-- 3 - A Diretoria quer saber se a quantidade de alunos ao longo dos anos aumentou
Select Count(*) As Quantidade_Alunos, d.ingresso As Ano
From discente d
Group By d.ingresso
Order By d.ingresso DESC;

-- 4-  A Diretoria quer saber se as notas dos alunos ao longo dos anos melhorou
Select AVG(r.nota) As Media_Nota, d.ingresso As Ano
From resultado r join discente d on r.idDiscente = d.idDiscente
Group By d.ingresso DESC;