drop database if exists escola;
create database escola;
use escola;
show databases;

create table alunos (
	id int auto_increment primary key,
    nome varchar(100) not null,
    email varchar(100) not null,
    data_nascimento date,
    turma_id int
);

create table professores (
	id int auto_increment primary key,
    nome varchar(100) not null,
    especialidade varchar(100)
);

create table turmas (
	id int auto_increment primary key,
    nome varchar(50) not null,
    professor_id int,
    horario time,
    foreign key (professor_id) references professores(id)
);

create table disciplinas (
	id int auto_increment primary key,
    nome varchar(100) not null,
    carga_horaria int
);

create table notas (
	id int auto_increment primary key,
    aluno_id int,
    disciplina_id int,
	nota decimal (2, 1),
    bimestre int,
    foreign key (aluno_id) references alunos(id),
    foreign key (disciplina_id) references disciplinas(id)
);

alter table alunos 
add foreign key (turma_id) references turmas(id);

insert into professores (nome, especialidade)
values
('Carlos Silva', 'Matemática'),
('Ana Santos', 'Português'),
('Marcos Lima', 'História'),
('Julia Costa', 'Ciências'),
('Roberto Alves', 'Geografia');

insert into turmas (nome, professor_id, horario)
values
('1º Ano A', 1, '08:00:00'),
('1º Ano B', 2, '10:00:00'),
('2º Ano A', 3, '08:00:00'),
('2º Ano B', 4, '13:00:00'),
('3º Ano A', 5, '14:00:00');

INSERT INTO disciplinas (nome, carga_horaria) VALUES
('Matemática', 80),    -- id 1
('Português', 80),     -- id 2  
('História', 60),      -- id 3
('Ciências', 60),      -- id 4
('Geografia', 60);     -- id 5

select * from professores;

select * from turmas;

insert into alunos (nome, email, data_nascimento, turma_id)
values
('João Pereira', 'joao@email.com', '2010-03-15', 1),
('Maria Santos', 'maria@email.com', '2010-07-22', 1),
('Pedro Oliveira', 'pedro@email.com', '2009-11-30', 2),
('Ana Costa', 'ana@email.com', '2010-01-10', 2),
('Lucas Martins', 'lucas@email.com', '2009-05-18', 3),
('Carla Rodrigues', 'carla@email.com', '2009-08-25', 3),
('Bruno Silva', 'bruno@email.com', '2008-12-05', 4),
('Fernanda Lima', 'fernanda@email.com', '2008-09-14', 4),
('Rafael Alves', 'rafael@email.com', '2008-04-20', 5),
('Patrícia Souza', 'patricia@email.com', '2008-06-08', 5);

select * from alunos;

insert into notas (aluno_id, disciplina_id, nota, bimestre)
values
(1, 1, 8.5, 1), (1, 1, 9.0, 2), (1, 1, 7.5, 3), (1, 1, 8.0, 4),
(1, 2, 7.0, 1), (1, 2, 8.5, 2), (1, 2, 9.0, 3), (1, 2, 7.5, 4),

(2, 1, 9.5, 1), (2, 1, 8.0, 2), (2, 1, 9.0, 3), (2, 1, 8.5, 4), 
(2, 2, 8.0, 1), (2, 2, 7.5, 2), (2, 2, 8.5, 3), (2, 2, 9.0, 4),  

(3, 3, 6.5, 1), (3, 3, 7.0, 2), (3, 3, 6.0, 3), (3, 3, 5.5, 4), 
(3, 4, 8.0, 1), (3, 4, 7.5, 2), (3, 4, 8.5, 3), (3, 4, 7.0, 4);

select * from notas;

-- Listar todos os alunos da turma 1°Ano A
select * from alunos
where turma_id = 1;

-- Listar todos os alunos em ordem alfabética
select * from alunos
order by nome;

-- Listar alunos nascidos após o ano de 2010 (coluna nome e data_nascimento)
select *from alunos 
where data_nascimento > '2010-01-01';

-- Listar quantos alunos tem em cada turma (Count)
select turma_id (count(turma_id)) as AlunoPorTurma
from alunos
group by turma_id
order by tuma_id;

-- Mostrar a média de notas por disciplina (AVG)
SELECT d.nome AS disciplina, AVG(n.nota) AS media_geral
FROM disciplinas d
JOIN notas n ON d.id = n.disciplina_id
GROUP BY d.id, d.nome;

-- INNER JOIN Básico
-- Alunos com suas turmas e professores
SELECT a.nome AS aluno, t.nome AS turma, p.nome AS professor
FROM alunos a
JOIN turmas t ON a.turma_id = t.id
JOIN professores p ON t.professor_id = p.id;

-- JOIN com múltiplas tabelas
-- notas dos alunos com detalhes
SELECT 
    a.nome AS aluno,
    d.nome AS disciplina,
    n.nota,
    n.bimestre
FROM notas n
JOIN alunos a ON n.aluno_id = a.id
JOIN disciplinas d ON n.disciplina_id = d.id
ORDER BY a.nome, d.nome, n.bimestre;

-- PROCEDURES
-- Para calcular média do aluno
DELIMITER //

CREATE PROCEDURE MediaAluno(IN aluno_id INT)
BEGIN
    SELECT 
        a.nome AS aluno,
        d.nome AS disciplina,
        AVG(n.nota) AS media_final
    FROM notas n
    JOIN alunos a ON n.aluno_id = a.id
    JOIN disciplinas d ON n.disciplina_id = d.id
    WHERE a.id = aluno_id
    GROUP BY a.nome, d.nome;
END//

DELIMITER ;

-- TESTAR: Calcular média do João Pereira (id 1)
CALL MediaAluno(1);

-- PROCEDURES
-- Para listar alunos por turma
DELIMITER //

CREATE PROCEDURE AlunosPorTurma(IN nome_turma VARCHAR(50))
BEGIN
    SELECT 
        a.nome AS aluno,
        a.email,
        a.data_nascimento
    FROM alunos a
    JOIN turmas t ON a.turma_id = t.id
    WHERE t.nome = nome_turma
    ORDER BY a.nome;
END//

DELIMITER ;

-- TESTAR: Listar alunos do 1º Ano A
CALL AlunosPorTurma('1º Ano A');

-- Query para mostrar Aprovado se nota maior que 7.0 ou reprovado se nota menor
SELECT 
    a.nome AS aluno,
    d.nome AS disciplina,
    AVG(n.nota) AS media,
    CASE 
        WHEN AVG(n.nota) >= 7.0 THEN 'Aprovado'
        ELSE 'Reprovado'
    END AS situacao
FROM notas n
JOIN alunos a ON n.aluno_id = a.id
JOIN disciplinas d ON n.disciplina_id = d.id
GROUP BY a.id, a.nome, d.id, d.nome
HAVING media > 7.0;

-- – Rankear os melhores alunos
SELECT 
    a.nome AS aluno,
    COUNT(n.id) AS total_notas,
    AVG(n.nota) AS media_geral
FROM alunos a
JOIN notas n ON a.id = n.aluno_id
GROUP BY a.id, a.nome
ORDER BY media_geral DESC
LIMIT 5;




















