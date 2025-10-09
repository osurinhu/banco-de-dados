
SELECT * FROM vendas_itens2;

SELECT
    venda_id,
    SUM(quantidade * valor_unitario) AS total_venda,
    data_venda
FROM
    vendas_itens2
GROUP BY
    venda_id,
    data_venda
ORDER BY
    total_venda DESC
LIMIT 1;

-- Venda de menor valor
SELECT
    venda_id,
    SUM(quantidade * valor_unitario) AS total_venda,
    data_venda
FROM
    vendas_itens2
GROUP BY
    venda_id,
    data_venda
ORDER BY
    total_venda ASC
LIMIT 1;

-- Produtos vendidos por unidade
SELECT *
FROM
    vendas_itens2
WHERE
    unidade LIKE 'U%'
ORDER BY
    valor_unitario ASC
LIMIT 20;

-- Produtos vendidos por kilogramas
SELECT *
FROM
    vendas_itens2
WHERE
    unidade LIKE '%g%'
ORDER BY
    valor_unitario ASC
LIMIT 20;

-- Adicionar campo de custo total
ALTER TABLE vendas_itens2
ADD COLUMN custo_total NUMERIC(12,2);

-- Atribuir valor ao campo custo_total
UPDATE vendas_itens2
SET custo_total = ROUND(quantidade * valor_unitario, 2);

-- Valor total de cada venda
SELECT
    venda_id,
    SUM(custo_total) AS total_venda,
    data_venda
FROM
    vendas_itens2
GROUP BY
    venda_id,
    data_venda
ORDER BY
    total_venda DESC;


-- Quantidade de vendas
SELECT
    count(DISTINCT venda_id) AS qtd_vendas
FROM
    vendas_itens2;

-- Quantidade de produtos
SELECT
    count(DISTINCT produto_id) AS qtd_produtos
FROM
    vendas_itens2;
