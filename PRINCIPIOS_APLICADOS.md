# Princípios de engenharia de software aplicados no projeto

## Regra 1 - Identificação
Todos os documentos estão versionados usando git, logo temos como rastrear **data**, **autoria** e **versão** deles.  
Como escrevemos todos os documentos em um formato texto, o tamanho em bytes dele cada um destes artefatos está diretamente ligado ao seu conteúdo, portanto este é um bom **indicador de conteúdo**.  
Tomamos cuidado para todo documento ter **título**.

## Regra 2 - Verificação
Todas as funções possuem pré e pós condições, que asseguram seu funcionamento nos contextos esperados.  

## Regra 3 - Modularização
Nos asseguramos que as soluções sejam subdivididas em 6 partes, independente do estilo. Para que isto ocorresse, foi necessário efetuar mudanças na estrutura do modelo de código do livro.
```
├── Solução
|   ├── Ler arquivo
|   ├── Filtrar e normalizar
|   ├── Escanear
|   ├── Remover palavras indesejáveis
|   ├── Recuperar palavras ordenadas por frequencia
|   └── Imprimir resultado
```

## Regra 4 - Não invente nomes
Criamos um banco de nomes, descrevendo o significado de cada um para o negócio envolvido no software. Desta forma evitamos nomes novos desconhecidos. As 4 soluções utilizam dos mesmos nomes para nomear conceitos em comum entre elas.

## Regra 5 - Desenho limpo
Tomamos cuidado para que funções e módulos fossem pequenos e que tivessem uma responsabilidade simples e bem determinada, para facilitar o entendimento dos mesmos. As funções que eram grandes foram divididas entre 3 e 6 seções demarcadas por comentários.

## Regra 6 - Registro diário
Todos os documentos estão versionados usando git, portanto temos o registro do trabalho feito por todos e uma estimativa razoavelmente confiável sobre o tempo de execução das tarefas.
