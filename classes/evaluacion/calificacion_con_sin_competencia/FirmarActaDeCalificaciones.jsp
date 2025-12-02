<%@ page language="java" 
	contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"
	import="java.sql.*,java.lang.*,java.util.*,java.text.DecimalFormat,evaluacion.*,comun.*" errorPage="../../error.jsp" 
	import="org.json.simple.JSONObject"
	%>
<%
try
{		
	int intCveDirector = Integer.parseInt(String.valueOf(session.getAttribute("clave_usuario")));
//out.println(intCveDirector);	
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
	ent.intCveDirector = intCveDirector;
	
	//-->> Verificar si ya existe el registro para saber si actualizar o insertar
	ent.verificarExisteRegistroFirma(intTipoActa);
//	out.println(ent.intExisteRegistroFirma);	
	
	if(ent.intExisteRegistroFirma>0)
	{
		ent.actualizarFirmaActa(intTipoActa);
		intResultado = ent.Result;
	}
	else
	{
		ent.insertarFirmaActa(intTipoActa);	
		intResultado = ent.Result;		
	}
	
	//Se crea un objeto tipo json (objeto de javascript)
	JSONObject json = new JSONObject();
	//--Inicio de despliegue de campos
    json.put("Resultado", intResultado); 
		
	//--Fin de despliegue de campos
	out.print(json); //se devuelve el resultado, imprimiendo el json completo (en este caso solo 1 valor)
    out.flush(); //Se libera la variable
}
catch (Exception error)
{
	out.println("Revisa tu error--> "+error);
}
%>
