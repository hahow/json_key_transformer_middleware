require 'hash_key_transformer'
require 'oj'

module JsonKeyTransformerMiddleware

  class OutgoingJsonFormatter < Middleware

    def call(env)
      status, headers, body = @app.call(env)

      return [status, headers, body] if should_skip?(env) || middleware_config.outgoing_should_skip_if.call(env)

      new_body = build_new_body(body)

      [status, headers, new_body]
    end

    private

    def build_new_body(body)
      Enumerator.new do |yielder|
        body.each do |body_part|
          yielder << (body_part != '' ? transform_outgoing_body_part(body_part) : '')
        end
      end
    end

    def transform_outgoing_body_part(body_part)
      object = nil

      begin
        object = Oj.load(body_part)
      rescue Oj::ParseError # ignore HTML, CSV ...etc
        return body_part
      end

      transformed_object = transform_outgoing(object)
      Oj.dump(transformed_object, mode: :compat)
    end

  end

end
