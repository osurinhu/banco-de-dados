SELECT * FROM vendas_itens2;

-- Valor total de cada venda
SELECT
    venda_id,
    ROUND(SUM(quantidade*valor_unitario),2) AS venda_total
FROM vendas_itens2
GROUP BY venda_id
ORDER by venda_id ASC;

-- Valor medio do total das vendas
SELECT
    ROUND(AVG(total_vendas)::numeric, 2) AS media_total_vendas
FROM 
    (SELECT
        venda_id,
        ROUND(SUM(quantidade*valor_unitario),2) AS total_vendas
    FROM
        vendas_itens2
    GROUP BY venda_id) AS sub_query;

-- Menor e maior venda
SELECT
    ROUND(MIN(total_vendas)::numeric, 2) AS menor_venda,
    ROUND(MAX(total_vendas)::numeric, 2) AS maior_venda
FROM
    (SELECT
        venda_id,
        ROUND(SUM(quantidade*valor_unitario),2) AS total_vendas
    FROM
        vendas_itens2
    GROUP BY venda_id) AS vendas_totais;

-- Menor venda com o id
SELECT
    venda_id, total_vendas
FROM 
    (SELECT
        venda_id,
        ROUND(SUM(quantidade*valor_unitario),2) AS total_vendas
    FROM 
        vendas_itens2
    GROUP BY venda_id) AS sub_query
WHERE total_vendas IN (
    SELECT
        MIN(total_vendas)
    FROM
        (SELECT
            venda_id,
            ROUND(SUM(quantidade*valor_unitario),2) AS total_vendas
        FROM
            vendas_itens2
        GROUP BY venda_id) AS venda_minima
);


-- Maior venda com o id
SELECT
    venda_id, total_vendas
FROM 
    (SELECT
        venda_id,
        ROUND(SUM(quantidade*valor_unitario),2) AS total_vendas
    FROM 
        vendas_itens2
    GROUP BY venda_id) AS sub_query
WHERE total_vendas IN (
    SELECT
        MAX(total_vendas)
    FROM
        (SELECT
            venda_id,
            ROUND(SUM(quantidade*valor_unitario),2) AS total_vendas
        FROM
            vendas_itens2
        GROUP BY venda_id) AS venda_minima
);

-- Valor medio por unidade considerando total vendido
SELECT
    produto_id,
    ROUND(produto_total_sub::numeric, 2) AS produto_total,
    ROUND(quantidade_total_sub::numeric, 2) AS quantidade_total,
    ROUND((produto_total_sub/NULLIF(quantidade_total_sub,0))::numeric,2) AS valor_medio_por_unidade
FROM
    (SELECT
        produto_id,
        SUM(quantidade*valor_unitario) AS produto_total_sub,
        SUM(quantidade) AS quantidade_total_sub
    FROM
        vendas_itens2
    GROUP BY
        produto_id) AS resumo_produto
ORDER BY
    produto_id;