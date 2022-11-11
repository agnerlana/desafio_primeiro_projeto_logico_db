##### Consultas ao banco de dados E-Commerce

-- Recuperacoes simples com SELECT Statement
SELECT * FROM cliente;
SELECT Nome_cliente, dt_nascimento, Sexo FROM cliente;

SELECT * FROM pedido;
SELECT idPedido, DATE_FORMAT(data_pedido, '%d/%m/%Y') AS data_pedido, Descricao, Status_pedido FROM pedido;

SELECT * FROM produto;
SELECT idProduto, Categoria, Nome_produto, Preço FROM produto;

-- Filtros com WHERE Statement
SELECT DISTINCT idCliente,
				Nome_cliente,
                dt_nascimento,
                Sexo
                FROM cliente
                WHERE Nome_cliente LIKE 'Jose%'
                OR Nome_cliente LIKE 'Maria%';

SELECT DISTINCT idPedido,
				DATE_FORMAT(data_pedido, '%d/%m/%Y') AS data_pedido,
                Descricao,
                Status_pedido
                FROM pedido
                WHERE data_pedido BETWEEN '2022-01-01' AND '2022-06-30';

SELECT DISTINCT idProduto,
				Categoria,
                Nome_produto,
                Preço
                FROM produto
                WHERE (Categoria = "Eletronicos" AND Preço >= 1500.00)
                OR (Categoria = "Utilidades" AND Preço < 100.00);

-- Crie expressões para gerar atributos derivados
SELECT DISTINCT idCliente,
				Nome_cliente,
                dt_nascimento,
                ROUND((DATEDIFF(CURRENT_DATE(), dt_nascimento) / 365),0) 'idade atual', # atributo derivado
                Sexo
                FROM cliente
                WHERE Nome_cliente LIKE 'Jose%'
                OR Nome_cliente LIKE 'Maria%';

SELECT DISTINCT A.idPedido,
                B.Nome_produto,
                B.Preço 'Preco_unitario',
                A.quantidade,
                ROUND(B.Preço * A.quantidade, 2) 'Valor total' # atributo derivado
                FROM pedido A, produto B, produtos_por_pedido C
                WHERE A.idPedido = C.Pedido_idPedido
                AND C.Produto_idProduto = B.idProduto;

-- Defina ordenaçoes dos dados com ORDER BY
SELECT DISTINCT idPedido,
				data_pedido,
                Descricao,
                Status_pedido
                FROM pedido
                WHERE Status_pedido = 'Entregue'
                ORDER BY data_pedido DESC;

SELECT DISTINCT idProduto,
				Categoria,
                Nome_produto,
                Preço
                FROM produto
                ORDER BY Preço DESC;

-- HAVING
# exemplo de consulta a ser agrupada
SELECT A.Nome_produto,
		B.local_estoque,
        C.Quantidade
        FROM produto A, estoque B, produtos_em_estoque C
        WHERE A.idProduto = C.Produto_idProduto
        AND B.idEstoque = C.Estoque_idEstoque
        ORDER BY A.Nome_produto;

# agrupando produtos em todos os estoques por nome do produto, filtrando onde total de produtos <= 500
SELECT A.Nome_produto,
        SUM(C.Quantidade) 'Total_produtos'
        FROM produto A, estoque B, produtos_em_estoque C
        WHERE A.idProduto = C.Produto_idProduto
        AND B.idEstoque = C.Estoque_idEstoque
        GROUP BY A.Nome_produto
        HAVING Total_produtos <= 500
        ORDER BY A.Nome_produto;

# agrupando produtos em todos os estoques por local do estoque, filtrando onde total de produtos <= 500
SELECT B.local_estoque,
        SUM(C.Quantidade) 'Total_produtos'
        FROM produto A, estoque B, produtos_em_estoque C
        WHERE A.idProduto = C.Produto_idProduto
        AND B.idEstoque = C.Estoque_idEstoque
        GROUP BY B.local_estoque
        HAVING Total_produtos <= 500
        ORDER BY B.local_estoque;


-- Criando junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
## Pedidos realizados por clientes (utilizando JOIN entre várias tabelas)
SELECT DISTINCT
	A.idCliente,
    A.Nome_cliente,
    B.Nome_produto,
    B.Categoria,
    B.Preço 'Preco_unitario',
    C.quantidade,
    ROUND(B.Preço * C.quantidade, 2) 'Valor total', # inserir total da compra aqui
    DATE_FORMAT(C.data_pedido,"%d/%m/%Y") 'data_pedido',
    C.Status_pedido,
    DATE_FORMAT(E.Data_envio,"%d/%m/%Y") 'data_envio',
    E.Codigo_rastreio
    FROM cliente A
    INNER JOIN pedido C ON A.idCliente = C.Cliente_idCliente
    LEFT JOIN  produtos_por_pedido D ON C.idPedido = D.Pedido_idPedido
    LEFT JOIN produto B ON B.idProduto = D.Produto_idProduto
    LEFT JOIN entrega E ON E.Pedido_idPedido = C.idPedido
	ORDER BY idCliente, data_pedido;


-- RESPONDENDO ALGUMAS PERGUNTAS COM QUERIES
# Quantos pedidos foram feitos por cada cliente?
SELECT A.Nome_cliente, COUNT(DISTINCT B.idPedido) 'total_pedidos'
	FROM cliente A, pedido B WHERE A.idCliente = B.Cliente_idCliente
    GROUP BY A.Nome_cliente
    ORDER BY total_pedidos DESC;
    
# Relação de produtos, fornecedores e estoques
SELECT A.Nome_produto 'Produto',
		C.Razao_social 'Fornecedor',
        E.local_estoque 'Estoque',
        D.Quantidade 'Quantidade'
        FROM produto A
        LEFT JOIN fornecendo_produtos B ON B.Produto_idProduto = A.idProduto
        LEFT JOIN fornecedor C ON C.idFornecedor = B.Fornecedor_idFornecedor
        LEFT JOIN produtos_em_estoque D ON D.Produto_idProduto = A.idProduto
        LEFT JOIN estoque E ON E.idEstoque = D.Estoque_idEstoque
        ORDER BY Fornecedor, Produto, Estoque;


#### Consultas realizadas conforme orientações do Desafio ####
