class GroupsCommands
    class << self
        def set_groups_columns
            Group.arrange_serializable.each do |group|
                Group.where(:id=>group['id']).update(:menu_columns=> group_column(group)) if group['ancestry'] == nil
            end
        end

        def group_column(group)
            count = tree_count(group).count
            case count
                when 0..19
                    return "1"
                when 20..60
                    return "2"
                else
                    return "3"
            end
        end

        def tree_count(tree, p = 0)
            id = tree["id"]
            (tree["children"] || [])
                .flat_map { |sub| tree_count(sub, id) }
                .unshift("id" => id, "parent_id" => p)
        end

        def set_site_title
            Group.find_each do |group|
                group.update(:site_title=>group.title.gsub(/^(\d*\.*)*/, '').strip )
            end
        end

        def set_new_item_time
            Group.with_new_items.each do |group|
            Group.where("id IN (?)",[group.id, group.root_id]).update_all(:last_new_item => group.item_created_at)
            end
        end

    end
end