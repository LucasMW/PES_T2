# Banco de nomes
* **text**: String com o texto usado como entrada para a análise de frequência ou cujo conteúdo é derivado de uma filtragem efetuada sobre o texto original.
* **word**: Palavra separada por espaço no **text** ou derivada de uma filtragem efetuada sobre o texto original.
* **words**: Lista de **word** separadas por espaço no **text** ou cujos elementos são derivados de uma filtragem efetuada sobre a original.
* **stop_word**: Palavra que não deve ser considerada na contagem de frequência.
* **stop_words**: Lista de **stop_words**. Esta lista é composta pelas palavras contidas em um arquivo texto de entrada e por uma lista com todos os caracteres, sejam eles especiais ou não.
* **frequency**: Quantidade de ocorrências de uma determinada palavra no **text**.
* **frequency_hash**: Estrutura de hash cujas chaves são as palavras e os valores são a **frequency**.
* **word_frequencies**: Lista de tuplas cujo primeiro elemento da tupla é uma palavra e o segundo é a **frequency** desta palavra.
