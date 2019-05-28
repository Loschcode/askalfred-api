ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Last tickets" do
          ul do
            Ticket.order(created_at: :desc).limit(10).map do |ticket|
              li link_to(ticket.title, admin_ticket_path(ticket))
            end
          end
        end
      end
      column do
        panel "Last identities" do
          ul do
            Identity.order(created_at: :desc).limit(10).map do |identity|
              li link_to(identity.email, admin_identity_path(identity))
            end
          end
        end
      end
    end
  end
end
