##### Criação do banco de dados E-Commerce
DROP DATABASE ecommerce;
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- tabela cliente
CREATE TABLE IF NOT EXISTS `ecommerce`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome_cliente` VARCHAR(45) NOT NULL,
  `dt_nascimento` DATE NOT NULL,
  `Sexo` ENUM("M", "F") NULL,
  `cpf_cnpj` VARCHAR(14) NOT NULL,
  `Endereco` VARCHAR(45) NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `cpf_cnpj_UNIQUE` (`cpf_cnpj` ASC) VISIBLE)
ENGINE = InnoDB;

-- tabela pagamentos
CREATE TABLE IF NOT EXISTS `ecommerce`.`pagamentos` (
  `idpagamentos` INT NOT NULL AUTO_INCREMENT,
  `numero_cartao` VARCHAR(16) NOT NULL,
  `nome_titular` VARCHAR(45) NOT NULL,
  `vencimento` VARCHAR(5) NOT NULL,
  `apelido_cartao` VARCHAR(10) NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idpagamentos`, `Cliente_idCliente`),
  INDEX `fk_pagamentos_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_pagamentos_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `ecommerce`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- tabela pedidos
CREATE TABLE IF NOT EXISTS `ecommerce`.`Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `data_pedido` DATETIME NOT NULL,
  `Descricao` VARCHAR(45) NOT NULL,
  `Status_pedido` VARCHAR(45) NOT NULL,
  `Frete` FLOAT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idPedido`, `Cliente_idCliente`),
  INDEX `fk_Pedido_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `ecommerce`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- tabela produtos
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `Categoria` VARCHAR(45) NOT NULL,
  `Nome_produto` VARCHAR(45) NOT NULL,
  `Descricao` VARCHAR(45) NOT NULL,
  `Preço` FLOAT NOT NULL,
  PRIMARY KEY (`idProduto`))
ENGINE = InnoDB;

-- relacionamento produtos por pedido
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produtos_por_pedido` (
  `Produto_idProduto` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `ecommerce`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- tabela estoques
CREATE TABLE IF NOT EXISTS `ecommerce`.`Estoque` (
  `idEstoque` INT NOT NULL,
  `Local` VARCHAR(45) NULL,
  PRIMARY KEY (`idEstoque`))
ENGINE = InnoDB;

-- relacionamento produtos em estoque
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produtos_em_estoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`Estoque_idEstoque` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `ecommerce`.`Estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- tabela fornecedor
CREATE TABLE IF NOT EXISTS `ecommerce`.`Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `Razao_social` VARCHAR(45) NOT NULL,
  `CNPJ` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`idFornecedor`))
ENGINE = InnoDB;

-- relacionamento fornecendo produtos
CREATE TABLE IF NOT EXISTS `ecommerce`.`Fornecendo_Produtos` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  INDEX `fk_Fornecedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Produto_Fornecedor1_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `ecommerce`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- tabela vendas_terceiros
CREATE TABLE IF NOT EXISTS `ecommerce`.`Vendas_terceiros` (
  `idVendas_terceiras` INT NOT NULL AUTO_INCREMENT,
  `Razao_social` VARCHAR(45) NOT NULL,
  `CNPJ` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idVendas_terceiras`))
ENGINE = InnoDB;

-- relacionamento produtos vendidos por terceiros
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produtos_vendidos_por_terceiros` (
  `Vendas_terceiros_idVendas_terceiras` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`Vendas_terceiros_idVendas_terceiras`, `Produto_idProduto`),
  INDEX `fk_Vendas_terceiros_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Vendas_terceiros_has_Produto_Vendas_terceiros1_idx` (`Vendas_terceiros_idVendas_terceiras` ASC) VISIBLE,
  CONSTRAINT `fk_Vendas_terceiros_has_Produto_Vendas_terceiros1`
    FOREIGN KEY (`Vendas_terceiros_idVendas_terceiras`)
    REFERENCES `ecommerce`.`Vendas_terceiros` (`idVendas_terceiras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vendas_terceiros_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- tabela entregas
CREATE TABLE IF NOT EXISTS `ecommerce`.`Entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `Status_entrega` VARCHAR(45) NULL,
  `Codigo_rastreio` VARCHAR(45) NULL,
  `Data_envio` DATE NULL,
  `Responsavel` VARCHAR(45) NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Vendas_terceiros_idVendas_terceiras` INT NOT NULL,
  PRIMARY KEY (`idEntrega`, `Pedido_idPedido`, `Vendas_terceiros_idVendas_terceiras`),
  INDEX `fk_Entrega_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Entrega_Vendas_terceiros1_idx` (`Vendas_terceiros_idVendas_terceiras` ASC) VISIBLE,
  CONSTRAINT `fk_Entrega_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `ecommerce`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Entrega_Vendas_terceiros1`
    FOREIGN KEY (`Vendas_terceiros_idVendas_terceiras`)
    REFERENCES `ecommerce`.`Vendas_terceiros` (`idVendas_terceiras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;





### Verificando informaçoes do banco de dados ecommerce
SELECT * FROM information_schema.columns WHERE table_schema = 'ecommerce';

-- Alterando o auto_increment de todas as tabelas que tem esta propriedade no ID
ALTER TABLE cliente AUTO_INCREMENT=1;
ALTER TABLE entrega AUTO_INCREMENT=1;
ALTER TABLE fornecedor AUTO_INCREMENT=1;
ALTER TABLE pagamentos AUTO_INCREMENT=1;
ALTER TABLE pedido AUTO_INCREMENT=1;
ALTER TABLE produto AUTO_INCREMENT=1;
ALTER TABLE vendas_terceiros AUTO_INCREMENT=1;




#### Persistindo e recuperando dados
-- Tabela cliente
DESC cliente;
INSERT INTO cliente (idCliente, Nome_cliente, dt_nascimento, Sexo, cpf_cnpj, Endereco) VALUES
						(1, 'Jose da Silva', '1970-05-01', 'M', '01234567890', 'Rua das Casas, 25'),
                        (2, 'Maria Pereira', '1981-10-08', 'F', '09874567890', 'Av Amazonas, 500'),
                        (3, 'Carlos Gomes', '1983-08-15', 'M', '04321567890', 'Beco das Flores, 73'),
                        (4, 'Valentina Rodrigues', '2002-02-23', 'F', '01234598760', 'Alameda Ezequiel Dias, 100');
SELECT * FROM cliente;


-- Tabela Pagamentos
DESC pagamentos;
INSERT INTO pagamentos (idpagamentos, numero_cartao, nome_titular, vencimento, apelido_cartao, Cliente_idCliente) VALUES
						(1, '8966496156788765', 'Jose da Silva', '05/23', NULL, 1),
                        (2, '7864432157898753', 'Maria Pereira', '10/25', NULL, 2),
                        (3, '8536432156788775', 'Carlos Gomes', '08/26', NULL, 3),
                        (4, '4568432156788749', 'Valentina Rodrigues', '02/24', NULL, 4);
SELECT * FROM pagamentos;

-- Tabela Produtos
DESC produto;
ALTER TABLE produto MODIFY Descricao VARCHAR(45) NULL;
INSERT INTO produto (idProduto, Categoria, Nome_produto, Descricao, Preço) VALUES
						(1, 'Eletronicos', 'Celular', NULL, 1599.90),
                        (2, 'Vestuario', 'Calça Jeans', NULL, 99.90),
                        (3, 'Alimentos e bebidas', 'Vodka', NULL, 139.90),
                        (4, 'Utilidades', 'Porta-chaves', NULL, 19.90);
SELECT * FROM produto;

-- Tabela Estoque
DESC estoque;
ALTER TABLE estoque RENAME COLUMN `Local` TO local_estoque;
INSERT INTO estoque (idEstoque, local_estoque) VALUES
						(1, 'São Paulo'),
                        (2, 'Belo Horizonte'),
                        (3, 'Rio de Janeiro');
SELECT * FROM estoque;

-- Tabela Produtos em Estoque
DESC produtos_em_estoque;
INSERT INTO produtos_em_estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) VALUES
						(1, 1, 150),
                        (1, 2, 50),
                        (2, 1, 500),
                        (2, 2, 500),
                        (3, 1, 1900),
                        (3, 2, 700),
                        (3, 3, 500),
                        (4, 2, 100);
SELECT * FROM produtos_em_estoque;


-- tabela Pedido
DESC pedido;
ALTER TABLE pedido ADD COLUMN quantidade INT DEFAULT NULL;
INSERT INTO pedido (idPedido, data_pedido, Descricao, Status_pedido, Cliente_idCliente, Frete, quantidade) VALUES
						(1, '2022-02-15', 'Celular', 'Entregue', 4, NULL, 1),
                        (2, '2022-07-10', 'Calça jeans', 'Entregue', 4, NULL, 2),
                        (3, '2022-08-19', 'Vodka', 'Cancelado', 3, NULL, 2),
                        (4, '2022-06-20', 'Vodka', 'Entregue', 4, NULL, 1),
                        (5, '2022-05-25', 'Celular', 'Entregue', 2, NULL, 1),
                        (6, '2022-11-08', 'Porta-chaves', 'Aguardando pagamento', 1, NULL, 1),
                        (7, '2022-08-30', 'Porta-chaves', 'Cancelado', 2, NULL, 2),
                        (8, '2022-09-20', 'Calça jeans', 'Entregue', 4, NULL, 1),
                        (9, '2022-11-10', 'Vodka', 'Aguardando pagamento', 1, NULL, 3),
                        (10, '2022-11-07', 'Celular', 'Em andamento', 3, NULL, 1);
SELECT * FROM pedido;


-- relacionamento produtos_por_pedido
DESC produtos_por_pedido;
INSERT INTO produtos_por_pedido (Produto_idProduto, Pedido_idPedido, quantidade) VALUES
						(1, 1, 1),
                        (2, 2, 2),
                        (3, 3, 2),
                        (3, 4, 1),
                        (1, 5, 1),
                        (4, 6, 1),
                        (4, 7, 2),
                        (2, 8, 1),
                        (3, 9, 3),
                        (1, 10, 1);
SELECT * FROM produtos_por_pedido;


-- tabela Entrega
DESC entrega;
ALTER TABLE entrega DROP PRIMARY KEY, ADD PRIMARY KEY (`idEntrega`); 
ALTER TABLE entrega MODIFY Vendas_terceiros_idVendas_terceiras INT NULL;
INSERT INTO entrega (idEntrega, Status_entrega, Codigo_rastreio, Data_envio, Responsavel, Pedido_idPedido, Vendas_terceiros_idVendas_terceiras) VALUES
						(1, 'Entregue', 'DBC332EFG', '2022-02-20', 'Marcos', 1, NULL),
                        (2, 'Entregue', 'BCA845EJK', '2022-07-15', 'Marcos', 2, NULL),
                        (3, 'Cancelado', NULL, NULL, NULL, 3, NULL),
                        (4, 'Entregue', 'DEC189EHS', '2022-06-25', 'Roberto', 4, NULL),
                        (5, 'Entregue', 'TFS453EXF', '2022-05-30', 'Roberto', 5, NULL),
                        (6, 'Aguardando pagamento', NULL, NULL, NULL, 6, NULL),
                        (7, 'Cancelado', NULL, NULL, NULL, 7, NULL),
                        (8, 'Entregue', 'SGF536CSA', '2022-09-25', 'Carlos', 8, NULL),
                        (9, 'Aguardando pagamento', NULL, NULL, NULL, 9, NULL),
                        (10, 'Preparando para envio', NULL, NULL, 'Carlos', 10, NULL);
SELECT * FROM entrega;

-- fornecedor
DESC fornecedor;
INSERT INTO fornecedor (idFornecedor, Razao_social, CNPJ) VALUES
						(1, 'Loja dos celulares', '01354876000120'),
                        (2, 'Comercio de Roupas', '25613214000100'),
                        (3, 'Distribuidora de bedidas', '56412321000110'),
                        (4, 'Lojinha de Utilidades', '48965312000120');
SELECT * FROM fornecedor;


-- relacionamento fornecendo produtos
DESC fornecendo_produtos;
INSERT INTO fornecendo_produtos (Fornecedor_idFornecedor, Produto_idProduto) VALUES
						(1, 1),
                        (2, 2),
                        (3, 3),
                        (4, 4);
SELECT * FROM fornecendo_produtos;

-- tabela vendas terceiros
DESC vendas_terceiros;
INSERT INTO vendas_terceiros (idVendas_terceiras, Razao_social, CNPJ) VALUES
						(1, 'Americanas', '23564326000110'),
                        (2, 'Amazon', '56522348000120');
SELECT * FROM vendas_terceiros;

-- relacionamento produtos vendidos por terceiros
DESC produtos_vendidos_por_terceiros;
INSERT INTO produtos_vendidos_por_terceiros (Vendas_terceiros_idVendas_terceiras, Produto_idProduto, Quantidade) VALUES
						(1, 1, NULL),
                        (1, 2, NULL),
                        (1, 3, NULL),
                        (2, 1, NULL),
                        (2, 2, NULL),
                        (2, 3, NULL),
                        (2, 4, NULL);
SELECT * FROM produtos_vendidos_por_terceiros;


### Verificando tabelas após preenchimento
SELECT * FROM cliente;
SELECT * FROM entrega;
SELECT * FROM estoque;
SELECT * FROM fornecedor;
SELECT * FROM fornecendo_produtos;
SELECT * FROM pagamentos;
SELECT * FROM pedido;
SELECT * FROM produto;
SELECT * FROM produtos_em_estoque;
SELECT * FROM produtos_por_pedido;
SELECT * FROM produtos_vendidos_por_terceiros;
SELECT * FROM vendas_terceiros;


#### Tabelas da base de dados ecommerce criadas e populadas ####
