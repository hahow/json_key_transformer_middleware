require 'hash_key_transformer'
require 'oj'

module JsonKeyTransformerMiddleware

  class OutgoingJsonFormatter < Middleware

    def call(env)
      status, headers, body = @app.call(env)

      return [status, headers, body] if should_skip?(env) || outgoing_should_skip?(env)

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
      begin
        object = Oj.load(body_part)
        transformed_object = transform_outgoing(object)
        Oj.dump(transformed_object, mode: :compat)
      rescue
        body_part
      end
    end

  end

end
