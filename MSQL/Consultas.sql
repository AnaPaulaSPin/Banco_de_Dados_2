-- 1. Listar todos os estados
SELECT * 
FROM Estado;

-- 2. Listar cidades com seu estado
SELECT c.idCidade, c.nome AS cidade, e.nome AS estado, e.uf
FROM Cidade c
JOIN Estado e ON c.idEstado = e.idEstado;

-- 3. Listar bairros com cidade e estado
SELECT b.idBairro, b.nome AS bairro, c.nome AS cidade, e.uf
FROM Bairro b
JOIN Cidade c ON b.idCidade = c.idCidade
JOIN Estado e ON c.idEstado = e.idEstado;

-- 4. Listar instituições
SELECT * 
FROM Instituicao;

-- 5. Listar campus com instituição e localização
SELECT cp.idCampus, cp.nome AS campus, i.nome AS instituicao, b.nome AS bairro, c.nome AS cidade, e.uf
FROM Campus cp
JOIN Instituicao i ON cp.idInstituicao = i.idInstituicao
JOIN Bairro b ON cp.idBairro = b.idBairro
JOIN Cidade c ON b.idCidade = c.idCidade
JOIN Estado e ON c.idEstado = e.idEstado;

-- 6. Listar cursos com campus
SELECT cr.idCurso, cr.nome AS curso, cr.turno, cp.nome AS campus
FROM Curso cr
JOIN Campus cp ON cr.idCampus = cp.idCampus;

-- 7. Listar disciplinas de cada curso
SELECT cr.nome AS curso, d.nome AS disciplina, d.carga_horaria
FROM Curso_Disciplina cd
JOIN Curso cr ON cd.idCurso = cr.idCurso
JOIN Disciplina d ON cd.idDisciplina = d.idDisciplina
ORDER BY cr.nome, d.nome;

-- 8. Quantidade de disciplinas por curso
SELECT cr.nome AS curso, COUNT(cd.idDisciplina) AS total_disciplinas
FROM Curso cr
LEFT JOIN Curso_Disciplina cd ON cr.idCurso = cd.idCurso
GROUP BY cr.idCurso, cr.nome;

-- 9. Listar todos os usuários com tipo
SELECT idUsuario, nome, email, tipo
FROM Usuario;

-- 10. Listar docentes com dados do usuário
SELECT d.idDocente, u.nome, u.email, d.titularidade, d.especialidades
FROM Docente d
JOIN Usuario u ON d.idUsuario = u.idUsuario;

-- 11. Listar discentes com curso
SELECT ds.idDiscente, u.nome AS aluno, ds.matricula, ds.ingresso, c.nome AS curso
FROM Discente ds
JOIN Usuario u ON ds.idUsuario = u.idUsuario
JOIN Curso c ON ds.idCurso = c.idCurso;

-- 12. Quantidade de alunos por curso
SELECT c.nome AS curso, COUNT(ds.idDiscente) AS total_alunos
FROM Curso c
LEFT JOIN Discente ds ON c.idCurso = ds.idCurso
GROUP BY c.idCurso, c.nome;

-- 13. Listar turmas com curso, disciplina e docente
SELECT t.idTurma, c.nome AS curso, d.nome AS disciplina, t.semestre, t.ano, u.nome AS docente
FROM Turma t
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Disciplina d ON t.idDisciplina = d.idDisciplina
JOIN Docente dc ON t.idDocente = dc.idDocente
JOIN Usuario u ON dc.idUsuario = u.idUsuario;

-- 14. Listar alunos matriculados em cada turma
SELECT t.idTurma, u.nome AS aluno, c.nome AS curso, d.nome AS disciplina
FROM Discente_Turma dt
JOIN Discente ds ON dt.idDiscente = ds.idDiscente
JOIN Usuario u ON ds.idUsuario = u.idUsuario
JOIN Turma t ON dt.idTurma = t.idTurma
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Disciplina d ON t.idDisciplina = d.idDisciplina
ORDER BY t.idTurma, u.nome;

-- 15. Quantidade de alunos por turma
SELECT t.idTurma, c.nome AS curso, d.nome AS disciplina, COUNT(dt.idDiscente) AS total_alunos
FROM Turma t
LEFT JOIN Discente_Turma dt ON t.idTurma = dt.idTurma
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Disciplina d ON t.idDisciplina = d.idDisciplina
GROUP BY t.idTurma, c.nome, d.nome;

-- 16. Listar questões com disciplina e docente responsável
SELECT q.idQuestao, q.enunciado, q.tipo, q.dificuldade, d.nome AS disciplina, u.nome AS docente
FROM Questao q
JOIN Disciplina d ON q.idDisciplina = d.idDisciplina
JOIN Docente dc ON q.idDocente = dc.idDocente
JOIN Usuario u ON dc.idUsuario = u.idUsuario;

-- 17. Listar alternativas de uma questão específica
SELECT a.idAlternativa, a.descricao, a.correta
FROM Alternativa a
WHERE a.idQuestao = 1;

-- 18. Listar avaliações com disciplina
SELECT av.idAvaliacao, av.titulo, av.data_criacao, d.nome AS disciplina
FROM Avaliacao av
JOIN Disciplina d ON av.idDisciplina = d.idDisciplina;

-- 19. Listar questões de cada avaliação
SELECT av.titulo AS avaliacao, q.enunciado
FROM Avaliacao_Questao aq
JOIN Avaliacao av ON aq.idAvaliacao = av.idAvaliacao
JOIN Questao q ON aq.idQuestao = q.idQuestao
ORDER BY av.titulo;

-- 20. Listar aplicações com turma e avaliação
SELECT ap.idAplicacao, ap.data_aplicacao, av.titulo AS avaliacao, t.idTurma
FROM Aplicacao ap
JOIN Avaliacao av ON ap.idAvaliacao = av.idAvaliacao
JOIN Turma t ON ap.idTurma = t.idTurma;

-- 21. Listar resultados dos alunos
SELECT r.idResultado, u.nome AS aluno, av.titulo AS avaliacao, r.nota
FROM Resultado r
JOIN Discente ds ON r.idDiscente = ds.idDiscente
JOIN Usuario u ON ds.idUsuario = u.idUsuario
JOIN Aplicacao ap ON r.idAplicacao = ap.idAplicacao
JOIN Avaliacao av ON ap.idAvaliacao = av.idAvaliacao;

-- 22. Média das notas por avaliação
SELECT av.titulo AS avaliacao, AVG(r.nota) AS media_notas
FROM Resultado r
JOIN Aplicacao ap ON r.idAplicacao = ap.idAplicacao
JOIN Avaliacao av ON ap.idAvaliacao = av.idAvaliacao
GROUP BY av.idAvaliacao, av.titulo;

-- 23. Maior e menor nota por avaliação
SELECT av.titulo AS avaliacao, MAX(r.nota) AS maior_nota, MIN(r.nota) AS menor_nota
FROM Resultado r
JOIN Aplicacao ap ON r.idAplicacao = ap.idAplicacao
JOIN Avaliacao av ON ap.idAvaliacao = av.idAvaliacao
GROUP BY av.idAvaliacao, av.titulo;

-- 24. Nome do aluno, curso, disciplina e nota
SELECT u.nome AS aluno, c.nome AS curso, d.nome AS disciplina, r.nota
FROM Resultado r
JOIN Discente ds ON r.idDiscente = ds.idDiscente
JOIN Usuario u ON ds.idUsuario = u.idUsuario
JOIN Aplicacao ap ON r.idAplicacao = ap.idAplicacao
JOIN Turma t ON ap.idTurma = t.idTurma
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Disciplina d ON t.idDisciplina = d.idDisciplina
ORDER BY u.nome;

-- 25. Docentes e quantidade de questões cadastradas
SELECT u.nome AS docente, COUNT(q.idQuestao) AS total_questoes
FROM Docente d
JOIN Usuario u ON d.idUsuario = u.idUsuario
LEFT JOIN Questao q ON d.idDocente = q.idDocente
GROUP BY d.idDocente, u.nome;

-- 26. Disciplinas que ainda não possuem questão cadastrada
SELECT d.idDisciplina, d.nome
FROM Disciplina d
LEFT JOIN Questao q ON d.idDisciplina = q.idDisciplina
WHERE q.idQuestao IS NULL;

-- 27. Cursos com suas turmas ofertadas
SELECT c.nome AS curso, COUNT(t.idTurma) AS total_turmas
FROM Curso c
LEFT JOIN Turma t ON c.idCurso = t.idCurso
GROUP BY c.idCurso, c.nome;
