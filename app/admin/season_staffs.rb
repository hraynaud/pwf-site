ActiveAdmin.register SeasonStaff do
  menu :parent => "Administration"
  permit_params :staff_id, :season_id

  config.filters = false

end
