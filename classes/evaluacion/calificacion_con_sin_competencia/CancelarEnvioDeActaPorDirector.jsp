<%@ page language="java" 
	contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"
	import="java.sql.*,java.lang.*,java.util.*,java.text.DecimalFormat,evaluacion.*,comun.*" errorPage="../../error.jsp" 
	import="org.json.simple.JSONObject"
	%>
<%
try
{		
	int intCvePeriodo = Integer.parseInt(request.getParameter("intCvePeriodo"));	
	int intCveCarrera = Integer.parseInt(request.getParameter("intCveCarrera"));	
	int intCveGrupo = Integer.parseInt(request.getParameter("intCveGrupo"));	
	int intTipoActa = Integer.parseInt(request.getParameter("intTipoActa"));				
	
	int error = 0;
	int intResultado = 0;
	
	entrega_aktaz ent = new entrega_aktaz(); 
	
	ent.intCvePeriodo = intCvePeriodo;
	ent.intCveCarrera = intCveCarrera;
	ent.intCveGrupo = intCveGrupo;
	ent.verificarTieneValidacionSE(intTipoActa);
	
	if(ent.intTieneValidacionSE==0)  //-->> No tiene validación de SE
	{
		ent.cancelarEnvioDeActaPorDirector(intTipoActa);
		intResultado = ent.Result;		
	}
	//Se crea un objeto tipo json (objeto de javascript)
	JSONObject json = new JSONObject();
	//--Inicio de despliegue de campos
    json.put("intResultado", intResultado); 
    json.put("intTieneValidacionSE", ent.intTieneValidacionSE); 	
		
	//--Fin de despliegue de campos
	out.print(json); //se devuelve el resultado, imprimiendo el json completo (en este caso solo 1 valor)
    out.flush(); //Se libera la variable
}
catch (Exception error)
{
	out.println("Revisa tu error--> "+error);
}
%>
