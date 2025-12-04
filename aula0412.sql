-- Criando usuários e permissões

select version();

create user 'analista_wilson'@'localhost';

set password for 'analista_wilson'@'localhost' = 
password('Wilson@2025');

alter user 'analista_wilson'@'localhost' 
password expire interval 90 day;

select user, Host from mysql.user
where user like '%wilson%';


create user 'usuario_ext'@'192.168.1.%';

set password for 'usuario_ext'@'192.168.1.%'
= password('Usuario@2025');

alter user 'usuario_ext'@'192.168.1.%' password expire never;

select user, Host from mysql.user
where user like '%usuario%';

select 
	user,
	host,
    password_expired as 'Senha Expirada?'
from mysql.user
where user not like 'mysql%'
	and user != 'root';
    
-- Criar usuário com privilégios específicos
create user 'usuario_leitor'@'localhost';

set password for 'usuario_leitor'@'localhost' = 
password('Leitor@2025');

create database if not exists empresa_dados;

show databases;

grant select on empresa_dados.* to 'usuario_leitor'@'localhost';

flush privileges;

show grants for 'usuario_leitor'@'localhost';

-- Criptogragando informações

create database loja_virtual;
use loja_virtual;

create table clientes (
	id int primary key auto_increment,
    nome_completo varchar(100) not null,
    cpf_visivel varchar(14),
    cpf_criptografado varbinary(255),
    email varchar(100),
    telefone varchar(20),
    data_cadastro timestamp default current_timestamp
);

create index idx_cliente_nome on clientes(nome_completo);

describe clientes;

set @minha_chave_secreta = 'MinhaSenhaForte@2025!';

insert into clientes 
(nome_completo, cpf_criptografado, email, telefone)
values ('Wilson Neto', aes_encrypt('123.456.789-00', @minha_chave_secreta),
'wilson@wilson.com', '(44)99999-1234)');

insert into clientes 
(nome_completo, cpf_criptografado, email, telefone)
values ('Carlos Junior', aes_encrypt('789.456.123.00', @minha_chave_secreta),
'junior@junior.com', '(44)98888-4321)');

select id, nome_completo, cpf_criptografado, email from clientes;

select HEX(cpf_criptografado) from clientes;

-- descriptografar
set @minha_chave_secreta = 'MinhaSenhaForte@2025!';

select id, nome_completo,
cast(aes_decrypt(cpf_criptografado, @minha_chave_secreta)
as char) as cpf_descriptografado,
email, telefone from clientes;



