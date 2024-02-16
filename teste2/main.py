import tabula
import pandas as pd
from zipfile import ZipFile, ZIP_DEFLATED

df = pd.DataFrame()

for i in range(3, 180):
    try:
        print(f'Pagina atual: {i}')
        tabela = tabula.read_pdf('Anexo_I_Rol_2021RN_465.2021_RN592.pdf', pages=f'{i}', output_format='dataframe')
    except tabula.errors.PageNumberError:
        print(f'Erro: A página {i} não existe no PDF.')
        continue
    
    dataframe_tabela = tabela[0]
    dataframe_atualizado = dataframe_tabela.replace({'OD': 'Seg. Odontológica', 'AMB': 'Seg. Ambulatorial'})
    df = pd.concat([df, dataframe_atualizado])

df.drop(df.columns[df.columns.str.contains('unnamed', case=False)], axis=1, inplace=True)

try:
    df.to_csv('Anexo I.csv',sep='\t', encoding="UTF-16")
except Exception as e:
    print(f'Erro: Falha ao converter o DataFrame para CSV. Erro: {e}')
    exit()

try:
    arquivozip = ZipFile('Teste_Joao_Arthur_Almeida_Gomes.zip', 'w', compression=ZIP_DEFLATED)
    arquivozip.write('Anexo I.csv')
    arquivozip.close()
except Exception as e:
    print(f'Erro: Falha ao compactar o arquivo CSV. Erro: {e}')
    exit()

print('Compressão finalizada.')
    

    