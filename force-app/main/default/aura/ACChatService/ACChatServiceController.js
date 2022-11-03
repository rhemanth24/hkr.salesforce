({
    afterScriptsLoaded: function (component, event, helper) {
        //console.log("Inside afterScriptsLoaded")
        //console.log(window)
        let contactFlowId = component.get('v.contactFlowId')
        let instanceId = component.get('v.instanceId')
        let apiGatewayARN = component.get('v.APIGateway')
        let InitiationIcon = component.get('v.InitiationIcon')
        let Region = component.get('v.Region')
        let PrimaryColor = component.get('v.PrimaryColor')
        let ChatForm = component.get('v.ChatForm')
        let Description = component.get('v.Description')

        //console.log(`contactFlowId: ${contactFlowId}`)
        //console.log(`instanceId: ${instanceId}`)
        AC.ChatInterface.init({
                containerId: 'root',
                initiationIcon: InitiationIcon, // icon/button
                region:Region,
                name: "refer|inputFields|Name", // **** Mandatory**** Add a constant or a variable for chat without form or if you have a form then you can refer it to the input fields like "refer|inputFields|Name"
                username: "refer|inputFields|UserName", // **** Mandatory**** Add a constant or a variable for chat without form or if you have a form then you can refer it to the input fields like "refer|inputFields|UserName"
                apiGateway: apiGatewayARN,
                contactFlowId:contactFlowId,
                instanceId: instanceId,
                contactAttr:{
                    Origin: "test", //Attach any custom contact attributes
                },
                preChatForm:{  // ChatForm True/False Enable/Disable the form below
                    visible: ChatForm,
                    inputFields:[
                        {
                            name: "Name",
                            contactAttr: "Name"
                        },{
                            name: "Email",
                            contactAttr: "email"
                        }
                    ]
                },
                primaryColor: PrimaryColor,  //Chat widget color
                description: Description // Title for the chat window
            })
    }
})