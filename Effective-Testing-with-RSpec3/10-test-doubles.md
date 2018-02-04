## Rest Doubles

Test doubles, like stunt doubles, stand in fo another object during testing so allowing you to isolate the part of the system your testing.
- this allows you to test a part of the system before it's dependencies are built
- use an API that your still designing, allowing you to fix design problems before implemnting them.
- demonstrate how a component works in relation to it's neighbours
- makes your tests faster and more resilient

There a several 'types' of doubles:

1. the 'stub' - returns a canned response, no computation or I/O carried out

2. the 'mock object' - expects a specific message, will raise an error if not received

3. 'null object' - can stand in for any object, returns itself in response to any message

4. the 'spy' - records the message received, whech can be checked later. 

A double ca be an instance of a Ruby object, an object provided by the test framework or a fake object that can be setup to have cetain properties/behaviour.