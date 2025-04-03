module ApplicationHelper
  # リソースのDOM IDを生成するヘルパーメソッド
  def resource_dom_id(resource, prefix = nil)
    [prefix, resource.class.name.underscore, resource.id].compact.join('_')
  end
end
