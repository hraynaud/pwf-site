ActiveAdmin.register_page "Dashboard" do
 menu priority: 0
 content do
   panel "Stats" do
   columns do
     column do
       section "Enrollment Stats", :priority => 1 do
         div do
           render  "season_summary" unless Season.current.nil?
         end
       end
     end


     column do
       div do
         pie_chart(Demographic.income_breakdown_for_current_confirmed_students, title: "Income level by student household", suffix: "%",legend: "bottom", download: true)
       end

       div do
         pie_chart(Demographic.education_level_breakown_for_current_confirmed_students, title: "Highest education level by student household", suffix: "%",legend: "bottom")
       end

       div do
         pie_chart(Demographic.home_ownership_breakown_for_current_confirmed_students, title: "Housing breakdown by student household", suffix: "%",legend: "bottom")
       end


     end
   end
   end
 end


  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.

  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end

  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
