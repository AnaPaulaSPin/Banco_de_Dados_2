USE faculdade;


-- =====================================================
-- 1. ÍNDICE: BUSCA POR NOTA (RESULTADO)
-- =====================================================
-- Criação do índice
CREATE INDEX idx_resultado_nota
ON Resultado(nota);

-- -------------------------------------
-- Consulta de teste (EXPLAIN)
-- -------------------------------------
Explain
Select * From resultado Where nota = 7;

-- -------------------------------------
-- Teste de performance
-- -------------------------------------
SET profiling = 1;
Select * From resultado Where nota = 7;
SHOW PROFILES; 



-- =====================================================
-- 2. ÍNDICE: BUSCA DE TURMAS POR CURSO
-- =====================================================
-- Criação do índice
CREATE INDEX idx_turma_curso
ON Turma(idCurso);

-- -------------------------------------
-- Consulta de teste (EXPLAIN)
-- -------------------------------------
EXPLAIN
SELECT av.titulo, t.idTurma, c.nome AS curso
FROM Aplicacao a
JOIN Turma t ON a.idTurma = t.idTurma
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Avaliacao av ON a.idAvaliacao = av.idAvaliacao
WHERE t.idCurso = 1;

-- -------------------------------------
-- Teste de performance
-- -------------------------------------
SET profiling = 1;
SELECT av.titulo, t.idTurma, c.nome AS curso
FROM Aplicacao a
JOIN Turma t ON a.idTurma = t.idTurma
JOIN Curso c ON t.idCurso = c.idCurso
JOIN Avaliacao av ON a.idAvaliacao = av.idAvaliacao
WHERE t.idCurso = 1;
SHOW PROFILES;


-- =====================================================
-- 3. ÍNDICE: BUSCA DE QUESTÕES POR DIFICULDADE
-- =====================================================

-- Criação do índice
CREATE INDEX idx_questao_dificuldade
ON Questao(dificuldade);

-- -------------------------------------
-- Consulta de teste (EXPLAIN)
-- -------------------------------------
EXPLAIN
SELECT *
FROM Questao
WHERE dificuldade = 2;

-- -------------------------------------
-- Teste de performance
-- -------------------------------------
SET profiling = 1;

SELECT *
FROM Questao
WHERE dificuldade = 2;

SHOW PROFILES;
