-- Criar banco de dados
DROP DATABASE IF EXISTS techstore;
CREATE DATABASE techstore;
USE techstore;

-- Tabela de categorias
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT
);

-- Tabela de produtos
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0,
    categoria_id INT,
    data_cadastro DATE DEFAULT CURDATE(),
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabela de clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    data_nascimento DATE,
    cidade VARCHAR(50),
    estado CHAR(2),
    data_cadastro DATE DEFAULT CURDATE()
);

-- Tabela de pedidos
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    data_pedido DATE DEFAULT CURDATE(),
    status ENUM('Pendente', 'Processando', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    total DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabela de itens do pedido
CREATE TABLE pedido_itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    produto_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- Tabela de funcionários
CREATE TABLE funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    cargo VARCHAR(50),
    salario DECIMAL(10,2),
    data_admissao DATE
);

-- POPULAÇÃO COM DADOS
INSERT INTO categorias (nome, descricao) VALUES
('Smartphones', 'Telefones inteligentes e celulares'),
('Notebooks', 'Computadores portáteis'),
('Tablets', 'Dispositivos tablet'),
('Acessórios', 'Capas, fones, carregadores'),
('Games', 'Consoles e jogos'),
('Áudio', 'Fones, caixas de som');

INSERT INTO produtos (nome, descricao, preco, estoque, categoria_id) VALUES
('iPhone 15 Pro', 'Smartphone Apple 128GB', 4500.00, 25, 1),
('Samsung Galaxy S23', 'Android 128GB Tela 6.1"', 3200.00, 30, 1),
('MacBook Air M2', 'Notebook Apple 13" 256GB', 8500.00, 15, 2),
('Dell Inspiron 15', 'Notebook Intel i5 8GB RAM', 2800.00, 20, 2),
('iPad Air', 'Tablet Apple 64GB 5ª Geração', 3500.00, 18, 3),
('Samsung Tab S8', 'Tablet Android 128GB', 2200.00, 12, 3),
('AirPods Pro', 'Fones Apple com cancelamento ativo', 1200.00, 40, 4),
('Capa iPhone Silicone', 'Capa original Apple', 199.90, 100, 4),
('PlayStation 5', 'Console Sony 825GB', 3800.00, 8, 5),
('Xbox Series X', 'Console Microsoft 1TB', 3500.00, 10, 5);

INSERT INTO clientes (nome, email, telefone, data_nascimento, cidade, estado) VALUES
('Ana Silva', 'ana.silva@email.com', '(11) 9999-1111', '1990-05-15', 'São Paulo', 'SP'),
('Carlos Oliveira', 'carlos.oliveira@email.com', '(21) 8888-2222', '1985-08-22', 'Rio de Janeiro', 'RJ'),
('Marina Costa', 'marina.costa@email.com', '(31) 7777-3333', '1992-12-10', 'Belo Horizonte', 'MG'),
('Ricardo Santos', 'ricardo.santos@email.com', '(41) 6666-4444', '1988-03-30', 'Curitiba', 'PR'),
('Fernanda Lima', 'fernanda.lima@email.com', '(51) 5555-5555', '1995-07-18', 'Porto Alegre', 'RS');

INSERT INTO funcionarios (nome, email, cargo, salario, data_admissao) VALUES
('João Pereira', 'joao.pereira@techstore.com', 'Vendedor', 2500.00, '2023-01-15'),
('Maria Oliveira', 'maria.oliveira@techstore.com', 'Gerente', 4500.00, '2022-03-10'),
('Pedro Costa', 'pedro.costa@techstore.com', 'Vendedor', 2300.00, '2023-06-20');

-- Inserir pedidos e itens
INSERT INTO pedidos (cliente_id, data_pedido, status, total) VALUES
(1, '2024-01-10', 'Entregue', 5700.00),
(2, '2024-01-12', 'Enviado', 3200.00),
(3, '2024-01-15', 'Processando', 199.90);

INSERT INTO pedido_itens (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 4500.00),  -- iPhone
(1, 7, 1, 1200.00),  -- AirPods
(2, 2, 1, 3200.00),  -- Samsung Galaxy
(3, 8, 1, 199.90);   -- Capa iPhone

show tables;

select * from clientes;

create view produtos_estoque_baixo as
select nome, estoque, preco
from produtos
where estoque < 15 and ativo = TRUE;

select * from produtos_estoque_baixo;

alter table produtos
add constraint chk_preco check (preco > 0),
add constraint chk_estoque check (estoque >= 0);

alter table produtos
add constraint  unq_nome_produto unique(nome);

show create table produtos;

insert into produtos (nome, preco, estoque)
values ('Mouse Gamer', 50, 5);

insert into produtos (nome, preco, estoque)
values ('Mouse Gamer', 150, 25);



create index idx_produtos_nome on produtos(nome);

create index odx_pedidos_clientes_data on pedidos(cliente_id, data_pedido);

create index idx_produtos_categoria_preco on produtos(categoria_id, preco);

explain select * from produtos where nome like 'iPhone%';

show tables;

create table impotacao_clientes (
	id int auto_increment primary key,
    nome_completo varchar(100),
    email varchar(100),
    telefone varchar(20),
    data_nascimento date,
    endereco varchar(200)
);

-- importar dados
load data infile 'C:/importacao_clientes.csv'
into table impotacao_clientes
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(nome_completo, email, telefone, data_nascimento, endereco);

select * from impotacao_clientes;

-- eportar dados
select 'nome', 'preco', 'estoque', 'categoria_id'
union all
select nome, preco, estoque, categoria_id
from produtos
into outfile 'C:/produtos_export.csv'
fields terminated by ','
enclosed by '"'
lines terminated by '/n';



