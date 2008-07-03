module XenConfigFileYouShouldntUse
  class ConfigFileNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      env[:variables] ||= [ ]
      elements.each do |e|
        begin
          e.eval(env)
        rescue => exception
          puts exception.backtrace
          pp "ZOMFG #{exception.message}"
        end
      end
      XenConfigFile::AST::ConfigFile.new(env)
    end
  end
  
  class AssignmentNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      env[:variables] << XenConfigFile::AST::Assignment.new(lhs.eval(env).to_sym, rhs.eval(env))
      env
    end
  end

  class ArrayAssignmentNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      env[:variables] << XenConfigFile::AST::ArrayAssignment.new(lhs.eval(env).to_sym, rhs.eval(env))
      env
    end
  end
  
  class CommentNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      env[:comments] ||= [ ]
      env[:comments].push(value.text_value)
    end
  end
  
  class ArrayListNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      variables.flatten
    end
  end
  
  class VariableNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      value.eval(env)
    end
  end
  
  class DoubleQuotedStringLiteralNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      XenConfigFile::AST::LiteralString.new(elements[1].text_value)
    end
  end
  
  class SingleQuotedStringLiteralNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      XenConfigFile::AST::LiteralString.new(elements[1].text_value)
    end
  end

  class StringLiteralNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      text_value
    end
  end
  
  class NumberNode < ::Treetop::Runtime::SyntaxNode
    def eval(env={})
      XenConfigFile::AST::LiteralNumber.new(text_value.to_i)
    end
  end
end