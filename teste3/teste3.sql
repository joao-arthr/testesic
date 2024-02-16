create database testeic;
use testeic;

/* 3.3. Crie queries para estruturar tabelas necessárias para o arquivo csv.8*/

CREATE TABLE Operadoras_ANS (
  Registro_ANS VARCHAR(20) NOT NULL PRIMARY KEY,
  CNPJ VARCHAR(14) NOT NULL,
  Razao_Social VARCHAR(255) NOT NULL,
  Nome_Fantasia VARCHAR(255),
  Modalidade VARCHAR(20),
  Logradouro VARCHAR(255),
  Numero VARCHAR(10),
  Complemento VARCHAR(255),
  Bairro VARCHAR(255),
  Cidade VARCHAR(255),
  UF VARCHAR(2),
  CEP VARCHAR(8),
  DDD VARCHAR(3),
  Telefone VARCHAR(10),
  Fax VARCHAR(10),
  Endereco_eletronico VARCHAR(255),
  Representante VARCHAR(255),
  Cargo_Representante VARCHAR(255),
  Regiao_de_Comercializacao VARCHAR(255),
  Data_Registro_ANS DATE
);

CREATE TABLE Demonstracoes_Contabeis (
  DATA DATE NOT NULL,
  REG_ANS VARCHAR(20) NOT NULL,
  CD_CONTA_CONTABIL VARCHAR(50) NOT NULL,
  DESCRICAO VARCHAR(500) NOT NULL,
  VL_SALDO_INICIAL DECIMAL(18,2) NOT NULL,
  VL_SALDO_FINAL DECIMAL(18,2) NOT NULL,
  PRIMARY KEY (DATA, REG_ANS, CD_CONTA_CONTABIL)
);

/* 3.4. Elabore queries para importar o conteúdo dos arquivos preparados, atentando para o encoding correto*/

-- Relatorio_cadop.csv
LOAD DATA INFILE 'arquivos/Relatorio_cadop.csv'
INTO TABLE Operadoras_ANS
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Registro_ANS, CNPJ, Razao_Social, Nome_Fantasia, Modalidade, Logradouro, Numero, Complemento, Bairro, Cidade, UF, CEP, DDD, Telefone, Fax, Endereco_eletronico, Representante, Cargo_Representante, Regiao_de_Comercializacao, Data_Registro_ANS);

-- 1T2022.csv
LOAD DATA INFILE 'arquivos/demonstracoes/1T2022.csv'
INTO TABLE Demonstracoes_Contabeis
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL);


-- 3T2022.csv
LOAD DATA INFILE 'arquivos/demonstracoes/3T2022.csv'
INTO TABLE Demonstracoes_Contabeis
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL);

-- 4T2022.csv
LOAD DATA INFILE 'arquivos/demonstracoes/4T2022.csv'
INTO TABLE Demonstracoes_Contabeis
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL);

-- 1T2023.csv
LOAD DATA INFILE 'arquivos/demonstracoes/1T2023.csv'
INTO TABLE Demonstracoes_Contabeis
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL);

-- 2T2023.csv
LOAD DATA INFILE 'arquivos/demonstracoes/2t2023.csv'
INTO TABLE Demonstracoes_Contabeis
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL);

-- 3T2023.csv
LOAD DATA INFILE 'arquivos/demonstracoes/3T2023.csv'
INTO TABLE Demonstracoes_Contabeis
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(DATA, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL);


/* 3.5. Desenvolva uma query analítica para responder*/

-- Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre
SELECT o.Registro_ANS, o.Razao_Social, o.Nome_Fantasia,
       SUM(d.VL_SALDO_FINAL) AS Despesas_Eventos
FROM Operadoras_ANS o
JOIN Demonstracoes_Contabeis d ON o.Registro_ANS = d.REG_ANS
WHERE YEAR(d.DATA) = YEAR(CURRENT_DATE() - INTERVAL 1 YEAR)
      AND d.DESCRICAO = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
      AND MONTH(d.DATA) = 7
GROUP BY o.Registro_ANS
ORDER BY Despesas_Eventos DESC
LIMIT 10;

-- Quais as 10 operadoras com maiores despesas nessa categoria no último ano
SELECT o.Registro_ANS, o.Razao_Social, o.Nome_Fantasia,
       SUM(d.VL_SALDO_FINAL) AS Despesas_Eventos
FROM Operadoras_ANS o
JOIN Demonstracoes_Contabeis d ON o.Registro_ANS = d.REG_ANS
WHERE YEAR(d.DATA) = YEAR(CURRENT_DATE() - INTERVAL 1 YEAR)
      AND d.DESCRICAO = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
GROUP BY o.Registro_ANS
ORDER BY Despesas_Eventos DESC
LIMIT 10;

