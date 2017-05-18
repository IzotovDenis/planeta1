class SearchHelper
    class << self 
        def indexes(where)
            case where
                when "code"
                    index = ["kod"]
                when "article"
                    index = ["article"]
                when "title"
                    index = ["full_name", "cross"]
                when "oem"
                    index = ["oem"]
                else
                    index = ["kod", "article", "full_name", "oem", "cross"]
                end
            index
        end

        def str_query(query_str, index="any")
            query = []
            string = query_str.dup
            #Оставляем только разрешенные символы
            string.gsub!(/[^0-9A-Za-zА-Яа-я]/, ' ')
            where_find = indexes(index)
            if where_find.include? "kod"
                query << kod_find(string) if kod_find(string)
                where_find.delete("kod")
            end
            if !where_find.empty?
                query << title_query(string,where_find)
            end
            query = query.join(" | ")
            query = "(#{query})"
            return query
        end

        def title_query(query, where_find)
            #создаем копию запроса
            string = query.dup
            #Оставляем только разрешенные символы
            # Формируем строку для поиска
            d = string_find(string)
            #Если в строке цифра добавляем разделяем ее пробелами
            d << " | #{string_find(string)}"
            string.gsub!(/(\d+)/, ' \1 ')
            d << " | #{string_find(string)}"
            string.delete!(" ")
            d << " | (#{string} | *#{string}*)"
            query = []
            where_find.each do |index|
                if index == 'oem'
                    query << "(@(#{index}) *#{string}*)"
                else
                    query << "(@(#{index}) #{d})"
                end
            end
            query
        end

        def string_find(string)
            d = []
            string.split(" ").each do |i|
                d << ["(#{i} | *#{i}*)"]
            end
            d = d.join(" & ")
            d = "( #{d} )"
            return d
        end

        def kod_find(string)
            query = "(@(kod) #{string})"
        end
    end
end