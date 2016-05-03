-- aplicação para contar quantidades de palavras que ocorrem num texto - estilo cookbook (cap.4)
-- Pedro Nascimento - 1213243

--ANOTAÇÔES
-- As maiores dificuldades foram:
-- não conhecer funções específicas de lua, 
-- trabalhar com Regxp 
-- trabalho para ordenar vetor associativo o que não pode ser feito, então tive que passar para um vetor para depois ordená-lo

-- O tempo total demorou 5 horas para a solução estar satisfeita
-- a estrutura da aplicação preservou bastante da notação do código do livro texto,
-- os nomes das variaveis em função seguiu o padrão pep8

text = ""
stop_words_lis = {}
count_word = {}
sorted = {}


function read_file()
file = io.open("words.txt")
text = file:read("*all") --extract words
end

function filter_chars_and_normalize()
text = string.lower(text)
text = string.gsub(text, "%s", ' ')
end

function scan()
stop_words_file = io.open("stop_words.txt")
stop_words = stop_words_file:read("*all")
stop_words_lis = {}
i=1
	for value in string.gmatch(stop_words, "%w+[\']*%w*") do
	 stop_words_lis[i] =value
	 i= i +1 
	end
 -- for i =1 , #stop_words_lis do
 -- print(stop_words_lis[i])
 -- end
end

function remove_stop_words()
for i = 1, #stop_words_lis do
text = string.gsub(text, "(%s"..stop_words_lis[i].."[%s|%x| %,]", ' ' )
text = string.gsub(text, ",", "")
end
end

function frequencies()
text = string.gsub(text, "%a*[^%s]", 
					function (w) 
						if count_word[w]==nil then
							count_word[w] =1
						else
							count_word[w]= count_word[w]+1
						end
					end)

-- for key,value in pairs(count_word) do
    -- print("word ".. key.." has " .. value);
-- end
end

function sort()
	i = 1
	for key,value in pairs(count_word) do
		sorted[i] = {key , value}
		i = i +1
	end
	
	table.sort(sorted, function (a,b) return a[2] >b[2] end)
	
	for i= 1, #sorted  do
		print(sorted[i][1] .. " " .. sorted[i][2]);
	end
end

read_file()
filter_chars_and_normalize()
scan()
remove_stop_words()
frequencies()
sort()

--FIM 
