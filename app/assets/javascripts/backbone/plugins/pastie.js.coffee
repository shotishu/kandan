class Kandan.Plugins.Pastie

  @options:
    maxPreviewLength: 300
    maxPreviewLines:  4
    regex: /\n.*\n/i

    template: _.template '''
      <pre class="pastie">
        <a target="_blank" class="pastie-link" href="<%= messageLink %>">View pastie</a>
        <br/><%= preview %>
      </pre>
    '''

  @truncate: (content)->
    originalLength = content.length
    content = content.split("/n").slice(0, @options.maxPreviewLines) if content.split("\n") > @options.maxPreviewLines
    content = content.substring(0, @options.maxPreviewLength)        if content.length > @options.maxPreviewLines
    return "#{content}..." if content.length != originalLength
    content


  @init: ->
    Kandan.Modifiers.register @options.regex, (message, state) =>
      url = "/channels/#{message.channel_id}/activities/#{message.id}"
      message.content = @options.template({preview: @truncate(message.content), messageLink: url})
      return Kandan.Helpers.Activities.buildFromMessageTemplate(message)
