CREATE TABLE cliente (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE produto (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL CHECK (preco > 0),
    estoque INT NOT NULL CHECK (estoque >= 0)
);

CREATE TABLE venda (
    id SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_venda TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    valor_total DECIMAL(12, 2) CHECK (valor_total >= 0),
    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id)
        ON DELETE RESTRICT
);

CREATE TABLE venda_produto (
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_venda, id_produto),
    FOREIGN KEY (id_venda) REFERENCES venda(id) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produto(id) ON DELETE RESTRICT
);

-- Inserindo Clientes
INSERT INTO cliente (nome, email) VALUES
('Ana Silva', 'ana.silva@email.com'),
('Bruno Costa', 'bruno.costa@email.com'),
('Carla Dias', 'carla.dias@email.com');

-- Inserindo Produtos
INSERT INTO produto (nome, preco, estoque) VALUES
('Notebook Gamer', 4500.00, 10),
('Mouse Sem Fio', 120.50, 50),
('Teclado Mecânico', 350.75, 25),
('Monitor 27"', 1800.00, 15);

-- Inserindo Vendas (Exemplo)
-- Venda 1: Ana comprou um Notebook e um Mouse
INSERT INTO venda (id_cliente, valor_total) VALUES (1, 4620.50);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 4500.00),
(1, 2, 1, 120.50);

-- Venda 2: Bruno comprou um Teclado
INSERT INTO venda (id_cliente, valor_total) VALUES (2, 350.75);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario) VALUES
(2, 3, 1, 350.75);

SELECT nome, preco, estoque
FROM produto
WHERE preco > 500.00
ORDER BY preco DESC;

SELECT
    v.id AS id_venda,
    v.data_venda,
    c.nome AS nome_cliente,
    v.valor_total
FROM 
    venda AS v 
INNER JOIN
    cliente AS c ON v.id_cliente = c.id;


SELECT
    p.nome AS produto,
    vp.quantidade,
    vp.preco_unitario
FROM
    venda_produto AS vp
JOIN
    produto AS p ON vp.id_produto = p.id
WHERE vp.id_venda = 1;
