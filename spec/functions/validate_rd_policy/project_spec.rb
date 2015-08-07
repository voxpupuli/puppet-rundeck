require 'spec_helper'

describe 'validate_rd_policy' do

  describe 'project policy' do
    describe 'valid policy' do
      test_policy = {
        'description' => 'Admin, all access',
        'context' => {
          'project' => '.*'
        },
        'for' => {
          'resource' => [
            { 'equals' => { 'kind' => 'job' }, 'allow' => ['create'] }
          ],
        },
        'by' => [{
          'group'    => ['admin'],
        }]
      }

      it { is_expected.to run.with_params(test_policy) }
    end

    describe 'invalid policy' do
      it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, //)}
     
      context "description" do 
        it { is_expected.to run.with_params({
          'context' => {
            'project' => '.*'
          }
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - description is not a String')}
      
        it { is_expected.to run.with_params({
          'description' => {}
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - description is not a String')}

      end

      context "context" do
        it { is_expected.to run.with_params({
          'description' => 'test'
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - context is not a Hash')}

        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {}
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - context is empty')}

        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => ''
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - context is not a Hash')}
      end

      context "context:project" do
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'fubar' => ''
          }
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - context can only be project or application')}

        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => {}
          }
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - context:project is not a String')}
      end
     
      context "for" do
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => ''
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for is not a Hash')}
      
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {}
        }).and_raise_error(Puppet::ParseError, 'The policy is invalid - for is empty')}
   
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'fubar' => {}
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for section must only contain ['job', 'node', 'adhoc', 'project', 'resource']")}
      end

      context "for:resource" do
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'resource' => ''
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource is not an Array")}

        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'resource' => {}
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource is not an Array")}

        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'resource' => []
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource is empty")}
      
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'resource' => [{}]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource does not contain a rule action of [allow,deny]")}

        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'resource' => [
              { 'equals' => { 'kind' => 'job' }, 'allow' => ['create'] },
              ''
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource entry is not a Hash")} 
     end

     context "for:resource rules" do 
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'resource' => [
              { 'equals' => { 'kind' => 'job' }, 'fubar' => ['create'] },
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource does not contain a rule action of [allow,deny]")}
     end

     context "for:resource matching" do
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'resource' => [
              { 'fubar' => { 'kind' => 'job' }, 'deny' => ['create'] },
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource does not contain a matching statement of [match,equals,contains]")}
     end

     context "for:resource kind:job" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
          },
          'for' => {
            'resource' => [
              { 'equals' => { 'kind' => 'job' }, 'allow' => ['x'] },
            ]
          }
       }).and_raise_error(Puppet::ParseError, /^The policy is invalid - for:resource kind:job can only contain actions/) }
     end

     context "for:resource kind:node" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'resource' => [
             { 'equals' => { 'kind' => 'node' }, 'allow' => ['x'] },
           ]
          }
        }).and_raise_error(Puppet::ParseError, /^The policy is invalid - for:resource kind:node can only contain actions/) }
     end

     context "for:resource kind:event" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'resource' => [
             { 'equals' => { 'kind' => 'event' }, 'allow' => ['x'] },
           ]
         }
       }).and_raise_error(Puppet::ParseError, /^The policy is invalid - for:resource kind:event can only contain actions/) }
     end

     context "for:adhoc" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'adhoc' => ''
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:adhoc is not an Array")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'adhoc' => {}
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:adhoc is not an Array")}
      
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'adhoc' => []
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:adhoc is empty")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'adhoc' => [{}]
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:adhoc does not contain a rule action of [allow,deny]")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'resource' => [
             { 'equals' => { 'kind' => 'job' }, 'allow' => ['create'] },
             ''
           ]
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:resource entry is not a Hash")} 
     end

     context "for:adhoc rules" do 
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'adhoc' => [
              { 'fubar' => ['create'] },
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:adhoc does not contain a rule action of [allow,deny]")}
     
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'adhoc' => [
             { 'allow' => ['x'] },
           ]
         }
       }).and_raise_error(Puppet::ParseError, /^The policy is invalid - for:adhoc can only contain actions/) }
     end
     
     context "for:job" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'job' => ''
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:job is not an Array")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'job' => {}
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:job is not an Array")}

       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'job' => []
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:job is empty")}
      
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'job' => [{}]
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:job does not contain a rule action of [allow,deny]")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'job' => [
             { 'allow' => ['create'] },
             ''
           ]
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:job entry is not a Hash")} 
     end

     context "for:job rules" do 
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'job' => [
              { 'equals' => { 'name' => 'job' }, 'fubar' => ['create'] },
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:job does not contain a rule action of [allow,deny]")}
     end

     context "for:job matching" do
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'job' => [
              { 'fubar' => { 'name' => 'job' }, 'deny' => ['create'] },
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:job does not contain a matching statement of [match,equals,contains]")}
     end

     context "for:job property:name" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'job' => [
             { 'equals' => { 'name' => 'test-job' }, 'allow' => ['x'] },
           ]
         }
       }).and_raise_error(Puppet::ParseError, /^The policy is invalid - for:job name:test-job can only contain actions/) }
     end

     context "for:job property:group" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'job' => [
             { 'equals' => { 'group' => 'test-group' }, 'allow' => ['x'] },
           ]
         }
       }).and_raise_error(Puppet::ParseError, /^The policy is invalid - for:job group:test-group can only contain actions/) }
     end

     context "for:node" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'node' => ''
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:node is not an Array")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'node' => {}
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:node is not an Array")}

       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'node' => []
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:node is empty")}
      
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'node' => [{}]
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:node does not contain a rule action of [allow,deny]")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'node' => [
             { 'allow' => ['read'] },
             ''
           ]
         }
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:node entry is not a Hash")} 
     end

     context "for:node rules" do 
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'node' => [
              { 'equals' => { 'name' => 'test.mycorp.com' }, 'fubar' => ['read'] },
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:node does not contain a rule action of [allow,deny]")}
     end

     context "for:node matching" do
        it { is_expected.to run.with_params({
          'description' => 'test',
          'context'     => {
            'project' => '.*'
          },
          'for' => {
            'node' => [
              { 'fubar' => { 'name' => 'job' }, 'deny' => ['read'] },
            ]
          }
        }).and_raise_error(Puppet::ParseError, "The policy is invalid - for:node does not contain a matching statement of [match,equals,contains]")}
     end

     context "for:node property:hostname" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'node' => [
             { 'equals' => { 'hostname' => 'test.mycorp.com' }, 'allow' => ['x'] },
           ]
         }
       }).and_raise_error(Puppet::ParseError, /^The policy is invalid - for:node can only contain actions/) }
     end

     context "by" do
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => {
           'node' => [
             { 'equals' => {'hostname' => 'test.mycorp.com' }, 'allow' => ['read'] }
           ]
         },
         'by' => ''
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - by is not an Array")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => { 
           'node' => [
             { 'equals' => {'hostname' => 'test.mycorp.com' }, 'allow' => ['read'] }
           ]
         },
         'by' => {}
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - by is not an Array")}

       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => { 
           'node' => [
             { 'equals' => {'hostname' => 'test.mycorp.com' }, 'allow' => ['read'] }
           ]
         },
         'by' => []
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - by is empty")}
      
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => { 
           'node' => [
             { 'equals' => {'hostname' => 'test.mycorp.com' }, 'allow' => ['read'] }
           ]
         },
         'by' => [{}]
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - by is empty")}
       
       it { is_expected.to run.with_params({
         'description' => 'test',
         'context'     => {
           'project' => '.*'
         },
         'for' => { 
           'node' => [
             { 'equals' => {'hostname' => 'test.mycorp.com' }, 'allow' => ['read'] }
           ]
         },
         'by' => [{'username'=>'test'},'']
       }).and_raise_error(Puppet::ParseError, "The policy is invalid - by: is not a Hash")} 
     end

   end
  end
end