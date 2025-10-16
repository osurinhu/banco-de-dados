CREATE TABLE fornecedor (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  site VARCHAR(100),
  telefone VARCHAR(15)
);


CREATE TABLE produtos (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  preco NUMERIC(12,2),
  estoque INTEGER DEFAULT 0,
  id_fornecedor INTEGER NOT NULL,
  CONSTRAINT fk_produto_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id)
);

CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  cidade VARCHAR(200),
  data_nascimento DATE
);


CREATE TABLE pedidos (
  id SERIAL PRIMARY KEY,
  data_pedido DATE DEFAULT CURRENT_DATE,
  id_cliente INTEGER,
  valor_total NUMERIC(12,2),
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE TABLE itens_pedido (
  id_pedido INTEGER NOT NULL,
  id_produto INTEGER NOT NULL,
  quantidade INTEGER NOT NULL,
  preco_unitario NUMERIC(12,2) NOT NULL,
  CONSTRAINT pk_itens_pedido PRIMARY KEY (id_pedido, id_produto),
  CONSTRAINT fk_item_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
  CONSTRAINT fk_item_pedido_produto FOREIGN KEY (id_produto) REFERENCES produtos(id)
);


INSERT INTO fornecedor (id, nome, site, telefone) VALUES
  (1, 'TechDistrib', 'https://techdistrib.com.br', '+5511999888777'),
  (2, 'CompCenter', 'https://compcenter.com.br', '+551132227788'),
  (3, 'InfoBrasil', 'https://infobrasil.com.br', '+551133445566');


INSERT INTO produtos (id, nome, preco, estoque, id_fornecedor) VALUES
  (1, 'Processador Intel Core i7-12700F', 1499.90, 10, 1),
  (2, 'Placa-mãe ASUS TUF B560', 899.50, 8, 1),
  (3, 'Memória RAM 16GB DDR4 3200 Kingston', 349.90, 20, 2),
  (4, 'SSD NVMe 1TB Samsung', 699.00, 15, 2),
  (5, 'Fonte 650W Corsair', 429.90, 12, 3),
  (6, 'Gabinete Mid Tower Cooler Master', 299.00, 10, 3),
  (7, 'Monitor 24" Full HD LG', 899.00, 7, 1),
  (8, 'Teclado Mecânico Redragon', 199.90, 25, 2),
  (9, 'Mouse Gamer Logitech G502', 249.90, 30, 3),
  (10, 'Webcam Logitech C920', 349.00, 18, 1);

INSERT INTO clientes (id, nome, email, cidade, data_nascimento) VALUES
  (1, 'João Silva', 'joao.silva@example.com', 'São Paulo', '1985-04-12'),
  (2, 'Maria Oliveira', 'maria.oliveira@example.com', 'Rio de Janeiro', '1990-11-03'),
  (3, 'Carlos Souza', 'carlos.souza@example.com', 'Belo Horizonte', '1978-07-20'),
  (4, 'Ana Pereira', 'ana.pereira@example.com', 'Salvador', '1995-01-25'),
  (5, 'Pedro Gomes', 'pedro.gomes@example.com', 'Curitiba', '1988-09-10');


INSERT INTO pedidos (id, data_pedido, id_cliente, valor_total) VALUES
  (1, '2025-10-01', 1, 2449.60),
  (2, '2025-10-02', 2, 699.00),
  (3, '2025-10-02', 3, 1329.40),
  (4, '2025-10-03', 4, 2346.90),
  (5, '2025-10-04', 5, 299.00),
  (6, '2025-10-05', 1, 2898.60),
  (7, '2025-10-06', 2, 3277.20),
  (8, '2025-10-07', 3, 449.80),
  (9, '2025-10-07', 4, 5276.10),
  (10,'2025-10-08', 5, 349.00);


INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (1, 1, 1, 1499.90),
  (1, 3, 2, 349.90),
  (1, 9, 1, 249.90);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (2, 4, 1, 699.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (3, 2, 1, 899.50),
  (3, 5, 1, 429.90);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (4, 7, 2, 899.00),
  (4, 8, 1, 199.90),
  (4,10, 1, 349.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (5, 6, 1, 299.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (6, 1, 1, 1499.90),
  (6, 4, 1, 699.00),
  (6, 8, 1, 199.90),
  (6, 9, 2, 249.90);


INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (7, 2, 1, 899.50),
  (7, 3, 2, 349.90),
  (7, 5, 1, 429.90),
  (7, 7, 1, 899.00),
  (7,10, 1, 349.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (8, 9, 1, 249.90),
  (8, 8, 1, 199.90);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (9, 1, 1, 1499.90),
  (9, 2, 1, 899.50),
  (9, 3, 1, 349.90),
  (9, 4, 1, 699.00),
  (9, 5, 1, 429.90),
  (9, 6, 1, 299.00),
  (9, 7, 1, 899.00),
  (9, 8, 1, 199.90);


INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (10, 10, 1, 349.00);


SELECT * FROM clientes;

SELECT * FROM pedidos;

-- INNER JOIN
SELECT
    p.id AS pedido_id,
    p.data_pedido,
    c.id AS cliente_id,
    c.nome AS cliente_nome
FROM
    pedidos p
INNER JOIN clientes c
    ON p.id_cliente = c.id;

-- Produtos mais vendidos (quantidade total vendida) usando o itens_pedido e produtos;
SELECT
    pr.id AS produto_id,
    pr.nome AS produto_nome,
    SUM(it.quantidade) AS total_unidades_vendidas
FROM
    itens_pedido it
INNER JOIN produtos pr
    ON it.id_produto = pr.id
GROUP BY
    pr.id,
    pr.nome
ORDER BY
    total_unidades_vendidas DESC;

SELECT * FROM clientes;

INSERT INTO clientes (id, nome, email, cidade, data_nascimento)
VALUES (6, 'Antonio de Padua', 'antonio.padua@example.com', 'Patos de Minas', '2005-12-02');

SELECT
    p.id AS pedido_id,
    p.data_pedido,
    c.id AS cliente_id,
    c.nome AS cliente_nome
FROM
    pedidos p
LEFT JOIN clientes c
    ON p.id_cliente = c.id;


SELECT
    c.nome AS cliente_nome,
    c.id AS cliente_id,
    p.id AS pedido_id,
    p.data_pedido
FROM
    clientes c
LEFT JOIN pedidos p
    ON p.id_cliente = c.id
ORDER BY cliente_id ASC;

SELECT 
    p1.id AS p1_id,
    p1.data_pedido AS p1_data,
    p2.id AS p2_id,
    p2.data_pedido AS p2_data
FROM pedidos AS p1
LEFT JOIN pedidos AS p2
    ON p1.data_pedido = p2.data_pedido AND p1.id != p2.id;

-- Listar todos os produtos e a quantidade total vendida (manter produtos sem venda)
SELECT 
    p.id AS id_produto,
    p.nome AS nome_produto,
    SUM(i.quantidade) AS total_vendido
FROM produtos p
LEFT JOIN itens_pedido i
    ON i.id_produto = p.id
GROUP BY p.id, p.nome
ORDER BY total_vendido ASC;

INSERT INTO produtos(id, nome, preco, estoque, id_fornecedor)
VALUES(11, 'Tablet Multilaser', 1356.90, 15, 2);

-- Itens pedidos com informações de produtos (garantir exibição de todos os produtos)
SELECT
    i.id_pedido AS id_pedido,
    p.nome AS nome_produto,
    i.quantidade AS quantidade
FROM produtos p
RIGHT JOIN itens_pedido i
    ON i.id_produto = p.id
ORDER BY i.id_pedido ASC;