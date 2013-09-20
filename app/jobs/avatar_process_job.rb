class AvatarProcessJob
  def initialize (id)
    @id = id
  end

  def perform
    student= Student.find(@id)
    student.remote_avatar_url = student.avatar.direct_fog_url(with_path: true)
    student.save!
  end
end
