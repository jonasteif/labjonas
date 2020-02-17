# labjonas
estrutura de arquivos terraform para deploy de uma estrutura AWS ALB+EC2


# Variaveis de ambiente

existe um arquivo cahmado variables.tf que contem algumas variaveis que precisam ser preenchidas para que o deploy dos recursos seja realizado com sucesso

São elas:

credentials_file
subnets
vpc_name
ami

Dentro do arquivo labjonas.tf a variável profile está definida como "default", caso for utilizar outro usuário que não o default declarado no arquivo credentials da AWS, gentileza preencher o nome correto nesta variavel da seguinte forma:

profile = <nome_do_usuario>