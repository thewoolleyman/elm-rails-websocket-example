module Commands
  class UpdateText
    def invoke(data)
      entity = TextualEntity.find_by_id(1)
      unless entity
        entity = TextualEntity.create(id: 1, text: '')
      end
      text = data.fetch('text')
      entity.update_attributes!(text: text)

      # generate event
      event = ::TextualEntityUpdated.new(
        data: JSON.generate({
          text: entity.text,
        })
      )
      event.save!
    end
  end
end
