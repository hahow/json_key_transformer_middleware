require 'hash_key_transformer'
require 'oj'

module JsonKeyTransformerMiddleware

  class IncomingJsonFormatter < Middleware

    def call(env)
      unless should_skip?(env) || incoming_should_skip?(env)
        object = Oj.load(env['rack.input'].read)
        transformed_object = transform_incoming(object)
        result = Oj.dump(transformed_object, mode: :compat)

        env['rack.input'] = StringIO.new(result)
        # Rails uses this elsewhere to parse 'rack.input', it must be updated to avoid truncation
        env['CONTENT_LENGTH'] = result.bytesize.to_s
      end

      @app.call(env)
    end

  end

end
