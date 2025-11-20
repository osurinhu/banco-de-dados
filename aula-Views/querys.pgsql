CREATE TABLE produto (
  produto_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  preco NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
  CONSTRAINT produto_nome_uniq UNIQUE (nome)
);

COMMENT ON TABLE produto IS 'Produtos vendidos na loja';
COMMENT ON COLUMN produto.preco IS 'Preço unitário em moeda local (>= 0)';

CREATE TABLE cliente (
  cliente_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  email VARCHAR(150) UNIQUE,
  identificador VARCHAR(50) UNIQUE NOT NULL,
  criado_em TIMESTAMPTZ DEFAULT now()
);

COMMENT ON TABLE cliente IS 'Clientes';
COMMENT ON COLUMN cliente.identificador IS 'Identificador único fornecido externamente (ex: matrícula, código)';

CREATE TABLE pedido (
  pedido_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cliente_id INT NOT NULL,
  data_pedido DATE NOT NULL,
  total_calculado NUMERIC(12,2) CHECK (total_calculado >= 0),
  CONSTRAINT pedido_cliente_data_uniq UNIQUE (cliente_id, data_pedido),
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id)
    REFERENCES cliente (cliente_id) ON DELETE CASCADE
);

COMMENT ON TABLE pedido IS 'Pedidos efetuados por clientes';
COMMENT ON COLUMN pedido.total_calculado IS 'Soma dos itens do pedido. Preferível recalcular via view ou manter por trigger';

CREATE TABLE pedido_item (
  pedido_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pedido_id INT NOT NULL,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
  CONSTRAINT pedido_item_unico_produto UNIQUE (pedido_id, produto_id),
  CONSTRAINT fk_pedido_item_pedido FOREIGN KEY (pedido_id)
    REFERENCES pedido (pedido_id) ON DELETE CASCADE,
  CONSTRAINT fk_pedido_item_produto FOREIGN KEY (produto_id)
    REFERENCES produto (produto_id)
);

COMMENT ON TABLE pedido_item IS 'Itens que compõem o pedido';

-- Inserir produtos
INSERT INTO produto (produto_id, nome, preco)
OVERRIDING SYSTEM VALUE
VALUES
  (1, 'Camiseta', 49.90),
  (2, 'Caneca',   25.00),
  (3, 'Caderno',  12.50),
  (4, 'Mouse',    89.90),
  (5, 'Teclado', 129.90),
  (6, 'Fone',     79.90);

-- Inserir clientes
INSERT INTO cliente (cliente_id, nome, email, identificador, criado_em)
OVERRIDING SYSTEM VALUE
VALUES
  (1, 'Ana Silva',   'ana@example.com',   '2023001', now()),
  (2, 'Bruno Costa', 'bruno@example.com', '2023002', now()),
  (3, 'Carla Souza', 'carla@example.com', '2023003', now()),
  (4, 'Daniel Reis', 'daniel@example.com', '2023004', now()),
  (5, 'Elisa Moraes','elisa@example.com', '2023005', now());

-- Inserir pedidos
INSERT INTO pedido (pedido_id, cliente_id, data_pedido, total_calculado)
OVERRIDING SYSTEM VALUE
VALUES
  (1, 1, '2025-10-01',  74.90),
  (2, 2, '2025-10-03',  89.90),
  (3, 3, '2025-09-30',  75.00),
  (4, 1, '2025-10-05',  79.90),
  (5, 4, '2025-10-02', 129.90),
  (6, 5, '2025-09-29',  50.00),
  (7, 2, '2025-10-06',  49.90),
  (8, 3, '2025-10-07', 179.80);

-- Inserir itens de pedido
INSERT INTO pedido_item (pedido_item_id, pedido_id, produto_id, quantidade, preco_unitario)
OVERRIDING SYSTEM VALUE
VALUES
  (1, 1, 1, 1, 49.90),
  (2, 1, 2, 1, 25.00),
  (3, 2, 4, 1, 89.90),
  (4, 3, 2, 3, 25.00),
  (5, 4, 6, 1, 79.90),
  (6, 5, 5, 1, 129.90),
  (7, 6, 3, 4, 12.50),
  (8, 7, 1, 1, 49.90),
  (9, 8, 5, 1, 129.90),
  (10, 8, 1, 1, 49.90);

SELECT pr.nome,
       SUM(pi.quantidade * pi.preco_unitario) AS total_vendido
FROM produto pr
JOIN pedido_item pi ON pr.produto_id = pi.produto_id
GROUP BY pr.produto_id, pr.nome
ORDER BY total_vendido DESC;

CREATE VIEW vw_produto_total_vendido AS
SELECT pr.produto_id,
       pr.nome,
       SUM(pi.quantidade * pi.preco_unitario) AS total_vendido
FROM produto pr
JOIN pedido_item pi ON pr.produto_id = pi.produto_id
GROUP BY pr.produto_id, pr.nome;

CREATE VIEW vw_cliente_faturamento AS
SELECT cl.nome, SUM(pe.total_calculado) AS total_faturamento
FROM cliente cl
JOIN pedido pe
    ON pe.cliente_id = cl.cliente_id
GROUP BY cl.nome
ORDER BY total_faturamento DESC;

CREATE VIEW vw_total_diario AS
SELECT data_pedido,
       SUM(total_calculado) AS total_diario
FROM pedido
GROUP BY data_pedido;

CREATE VIEW vw_soma_itens_por_pedido AS
SELECT p.pedido_id,
       c.nome,
       SUM(pi.quantidade * pi.preco_unitario) AS soma_itens
FROM pedido p
JOIN pedido_item pi ON p.pedido_id = pi.pedido_id
JOIN cliente c ON p.cliente_id = c.cliente_id
GROUP BY p.pedido_id, c.nome;