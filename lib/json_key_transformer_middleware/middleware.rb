module JsonKeyTransformerMiddleware

  class Middleware
    def initialize(app, middleware_config)
      @app = app
      @middleware_config = middleware_config
    end

    protected

    def should_skip?(env)
      check_skip_paths(env) || check_should_skip_if(env)
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

    def check_should_skip_if(env)
      return false unless middleware_config.should_skip_if.is_a? Proc

      middleware_config.should_skip_if.call(env)
    end

  end

end
