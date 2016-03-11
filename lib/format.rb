module Format
  def self.formatted_heredoc(doc)
    puts doc.split("\n").map(&:lstrip).join("\n")
  end
  def formatted_heredoc(doc)
    self.class.formatted_heredoc(doc)
  end
end
