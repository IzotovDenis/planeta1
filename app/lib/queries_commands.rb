class QueriesCommands
    class << self 
        def build_query(properties = false, show_qty = false, price)
            if properties
                @properties = 	"	replace(items.text, '\n', '<br>') as text,
                                    items.properties-> 'Страна изготовитель' as country,
                                    items.properties-> 'Применяемость' as applicability,
                                    items.properties-> 'Количество в упаковке' as in_pack,
                                    items.cross,
                                    items.properties-> 'Тип' as type,
                                    groups.title as group_title,
                                    items.group_id,
                                "
            else
                @properties = ''
            end

            if show_qty
                @show_qty = "CASE  WHEN items.qty BETWEEN 0 AND 9 THEN items.qty::text
                            WHEN items.qty BETWEEN 10 AND 49 THEN '10-49'::text
                            WHEN items.qty BETWEEN 50 AND 100 THEN '50-100'::text
                            ELSE '> 100'::text END as qty,"
            else
                @show_qty = "CASE  WHEN items.qty BETWEEN 1 AND 1000000 THEN 'in_stock'::text
                            ELSE 'out_of_stock'::text END as qty,"
            end
            @is_new = "CASE WHEN current_date-items.created_at::date BETWEEN 0 AND 7 THEN true
                        ELSE false END as new_label,"
            return        "
                            items.article,
                            items.full_title as title,
                            items.id,
                            items.properties-> 'Код товара' as kod,
                            items.properties-> 'ОЕМ' as oems,
                            items.properties-> 'Размер' as size,
                            array_to_string(items.cross, ' ', '*') as cross,
                            #{@properties}
                            #{@is_new}
                            #{@show_qty}
                            CASE coalesce(items.image,	 'null') WHEN 'null' THEN 'false'::boolean ELSE 'true' END AS image,
                            CASE coalesce(items.label->'discount', 'null') WHEN 'null' THEN 0 ELSE (items.bids->'#{price}'->>'value')::float*currencies.val END AS old_price,
                            items.created_at,
                    coalesce((coalesce((items.label->'discount')::float*(items.bids->'#{price}'->>'value')::float, (items.bids->'#{price}'->>'value')::float))*currencies.val, '0.00') as price,
                    coalesce(items.bids->'#{price}'->>'unit' , 'шт.') as unit"
        end
    end 
end
