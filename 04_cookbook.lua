-- aplicação para contar quantidades de palavras que ocorrem num texto - estilo cookbook (cap.4)
-- Pedro Nascimento - 1213243
-- Data: 03/05/2016

--ANOTAÇÔES
-- As maiores dificuldades foram:
-- não conhecer funções específicas de lua, 
-- trabalhar com Regxp 
-- trabalho para ordenar vetor associativo o que não pode ser feito, então tive que passar para um vetor para depois ordená-lo

-- O tempo total demorou 5 horas para a solução estar satisfeita
-- a estrutura da aplicação preservou bastante da notação do código do livro texto,
-- a aplicação seguiu o padrão pep8, cujo o mesmo é feito no livro texto

text = "" 
stop_words_lis = {}
count_word = {}
sorted = {}


function read_file()
-- lê o arquivo que contém o texto alvo da aplicação
-- pré-condição a abertura do arquivo está correta
-- pós-condição o texto extraído tem tamanho maior que 0
file = assert(io.open("input/words.txt"), "erro na abertura do arquivo")
text = file:read("*all") --extract words
assert(#text>0, "error, texto vazio")
end

function filter_chars_and_normalize()
-- filtra o texto retirando os Carriage Return , virgulas e pontos
-- pré condição: texto cru
-- pós-condição: texto filtrado
text = string.lower(text)
text = string.gsub(text, "%s", ' ') -- troca \n por espaços em brancos
text = string.gsub(text, "%,", "")
text = string.gsub(text, "%.", "")
assert(string.gsub(text, "%u", function () assert("letra maiuscula detectada, filtro errado") end))
assert(string.gsub(text, "%.", function () assert("virgula detectada, filtro errado") end))
assert(string.gsub(text, "%,", function () assert("ponto detectada, filtro errado") end))
end

function scan()
-- lê stop words, palavras que são vazias de significado
-- pré-condição, lista de texto com stop words
-- pós-condição, table com valores de stop words
stop_words_file = assert(io.open("input/stop_words.txt"), "erro na abertura de arquivo de stop_words")
stop_words = stop_words_file:read("*all")
stop_words_lis = {}
i=1
	for value in string.gmatch(stop_words, "[^,]+") do
	 stop_words_lis[i] =value
	 i= i +1 
	end
	assert(#stop_words_lis >0 , "erro lista de stop words vazio")
 end

function remove_stop_words()
-- remove stop words do texto
-- pré-condição: texto filtrado e table de stop_words
-- pós-condição: texto com palavras removidas 
for i = 1, #stop_words_lis do
text = string.gsub(text, "(%s"..stop_words_lis[i].."[%s|%x| %,]", ' ' )
	
end
end

function frequencies()
-- conta a quantidade que o texto aparece na busca
-- pré-cond: texto sem stop words
-- pós-cond: palavras contadas num array associativo (key, frequencia)
text = string.gsub(text, "%a*[^%s]", 
					function (w) 
						if count_word[w]==nil then
							count_word[w] =1
						else
							count_word[w]= count_word[w]+1
						end
					end)
					assert(count_word ~= nil , "erro count_word vazio") -- count_word deve ser diferente de nil
end

function sort()
-- ordena as palavras em ordem decrescente de frequencia em um array
-- pré-cond: vetor associativo de frequencia de palavras
-- pós-cond: array ordenado com as respectivas palavras e valor de frequencia
	i = 1
	for key,value in pairs(count_word) do
		sorted[i] = {key , value}
		i = i +1
	end
	
	table.sort(sorted, function (a,b) return a[2] >b[2] end)
end

function main ()
	read_file()
	filter_chars_and_normalize()
	scan()
	remove_stop_words()
	frequencies()
	sort()

	for i= 1, math.min(#sorted, 25)  do
		print(sorted[i][1] .. " " .. sorted[i][2]);
	end
end

main()
--FIM 
