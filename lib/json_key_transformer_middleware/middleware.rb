module JsonKeyTransformerMiddleware

  class Middleware
    def initialize(app, middleware_config)
      @app = app
      @middleware_config = middleware_config
    end

    protected

    def should_skip?(env)
      check_skip_paths(env) || check_content_type(env) || check_should_skip_if(env)
    end

    def incoming_should_skip?(env)
      return false unless middleware_config.incoming_should_skip_if.is_a? Proc

      middleware_config.incoming_should_skip_if.call(env)
    end

    def outgoing_should_skip?(env)
      return false unless middleware_config.outgoing_should_skip_if.is_a? Proc

      middleware_config.outgoing_should_skip_if.call(env)
    end

    private

    attr_reader :app, :middleware_config

    def check_skip_paths(env)
      middleware_config.skip_paths.any? do |skip_path|
        case skip_path
        when String
          skip_path == env['PATH_INFO']
        when Regexp
          skip_path.match? env['PATH_INFO']
        end
      end
    end

    def check_content_type(env)
      return false unless middleware_config.check_content_type

      request = Rack::Request.new(env)
      return false if request.content_type.nil? # Do not skip if Content-Type is unknown

      !%r{application/json}.match?(request.content_type)
    end

    def check_should_skip_if(env)
      return false unless middleware_config.should_skip_if.is_a? Proc

      middleware_config.should_skip_if.call(env)
    end

    def transform_incoming(object)
      transform(object, middleware_config.incoming_strategy, middleware_config.incoming_strategy_options)
    end

    def transform_outgoing(object)
      transform(object, middleware_config.outgoing_strategy, middleware_config.outgoing_strategy_options)
    end

    def transform(object, strategy, strategy_options)
      if strategy.is_a? Proc
        strategy.call(object)
      else
        HashKeyTransformer.send(strategy, object, strategy_options)
      end
    end

  end

end
