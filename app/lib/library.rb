module FromHash
  def from_hash(hash)
    hash.each do |k, v|
      public_send("#{k}=", v)
    end
  end
end
