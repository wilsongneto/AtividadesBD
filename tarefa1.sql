drop database if exists loja;
create database loja;
use loja;

show databases;

create table produtos (
	id int primary key auto_increment,
    nome varchar(100) not null,
    preco decimal(10, 2) not null,
    estoque int not null
);

desc produtos;

create table vendas (
	id int auto_increment primary key,
    produto_id int,
    produto varchar(100) not null,
    quantidade int not null,
    valor_total decimal(10, 2) not null,
    data_venda date not null,
    foreign key (produto_id) references produtos(id)
);

desc vendas;


INSERT INTO produtos (nome, preco, estoque) VALUES
('Notebook Gamer X', 5500.00, 15),
('Mouse Sem Fio Ultra', 120.50, 80),
('Teclado Mecânico RGB', 350.90, 45),
('Monitor 27 Polegadas 4K', 1899.99, 22),
('Webcam Full HD Pro', 95.00, 60),
('Fone de Ouvido Bluetooth', 180.75, 110),
('Placa de Vídeo RTX 4080', 7999.00, 10),
('SSD 1TB NVMe', 450.00, 75),
('Memória RAM 16GB DDR5', 680.50, 55),
('Roteador Wi-Fi 6', 299.90, 30),
('Câmera DSLR Canon', 3200.00, 18),
('Tripé para Câmera Profissional', 150.00, 40),
('Microfone Condensador USB', 210.00, 90),
('Smart TV 55 Polegadas OLED', 4200.00, 12),
('Console de Vídeo Game PS5', 4500.00, 25),
('Controle Extra PS5 DualSense', 350.00, 65),
('Impressora Multifuncional', 850.00, 50),
('Caixa de Som Portátil JBL', 499.99, 100),
('Carregador Portátil 20000mAh', 130.00, 120),
('Smartwatch Série 9', 1900.00, 35);

select * from produtos;

insert into vendas (produto_id, produto, quantidade, valor_total, data_venda)
values
(1, 'Notebook Gamer X', 4, 22000.00, date_sub(curdate(), interval 1 day));

INSERT INTO vendas (produto_id, produto, quantidade, valor_total, data_venda) VALUES
(1, 'Notebook Gamer X', 4, 22000.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(2, 'Mouse Sem Fio Ultra', 10, 1205.00, CURDATE()),
(3, 'Teclado Mecânico RGB', 3, 1052.70, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(4, 'Monitor 27 Polegadas 4K', 2, 3799.98, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(5, 'Webcam Full HD Pro', 8, 760.00, CURDATE()),
(6, 'Fone de Ouvido Bluetooth', 5, 903.75, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(7, 'Placa de Vídeo RTX 4080', 1, 7999.00, DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
(8, 'SSD 1TB NVMe', 6, 2700.00, CURDATE()),
(9, 'Memória RAM 16GB DDR5', 4, 2722.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(10, 'Roteador Wi-Fi 6', 7, 2099.30, DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
(11, 'Câmera DSLR Canon', 1, 3200.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(12, 'Tripé Profissional', 9, 1350.00, CURDATE()),
(13, 'Microfone Condensador USB', 2, 420.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(14, 'Smart TV 55 Polegadas OLED', 3, 12600.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(15, 'Console de Vídeo Game PS5', 5, 22500.00, CURDATE());

select * from vendas;

select produto, data_venda from vendas;

select * from vendas
where quantidade >= 3;

select * from vendas 
where data_venda <= curdate() - interval 4 day;

-- Delimitador temporário para criar o bloco de código

delimiter //

create procedure AplicadorDeDescontoGeral(in porcentagem decimal(5, 2))
begin
 -- Atualizar a tabela de produtos aplicando o desconto
	update produtos
    set preco = preco * (1 - (porcentagem / 100));
-- Informar quantas linhas foram afetadas
	select concat('Desconto de ', porcentagem, '% aplicado em ', row_count(),
     ' produtos.') as Resultado;
end //
delimiter ;

select * from produtos;

SET SQL_SAFE_UPDATES = 0;

call AplicadorDeDescontoGeral(15.0);

select * from produtos;


