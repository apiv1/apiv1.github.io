def obj_filter(obj, *filters)
  filters.to_h { |item| [item.to_sym, (obj.try(item) || obj[item])] }.compact
end
