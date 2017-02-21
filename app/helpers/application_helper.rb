module ApplicationHelper

  def edit_and_destroy_buttons(item)
    if current_user
      edit = link_to('Edit', url_for([:edit, item]), class:"btn btn-warning btn-sm")
      del = link_to('Delete', item, method: :delete,
                    data: {confirm: 'Are you sure?' }, class:"btn btn-danger btn-sm")
      raw("#{edit} #{del}")
    end
  end

  def round(param)
    number_with_precision(param, precision: 1)
  end

end
