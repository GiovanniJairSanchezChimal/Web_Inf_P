<%@ page language="java" 
                contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"
                import="java.sql.*,java.lang.*,java.util.*, comun.*, certificacion_ciut.*" errorPage="../../error.jsp" 
                import="org.json.simple.JSONObject"
%>
<%
if (session.getAttribute("usuario") == null)
{
	out.print("FAVOR DE INICIAR SESION NUEVAMENTE");
}
else
{
int cuenta_correctos=0;
int cve_persona=Integer.parseInt(String.valueOf(session.getAttribute("clave_usuario")));	
try
{		
		CIUT_certificacion ce=new CIUT_certificacion();
		
		ce.cve_registro=Integer.parseInt(request.getParameter("p_cve_registro"));
		ce.cve_persona= Integer.parseInt(request.getParameter("p_cve_persona"));		
		int tipo_observacion = Integer.parseInt(request.getParameter("p_tipo_observacion"));

		if(tipo_observacion==1)
		{
			ce.cve_persona_atiende=cve_persona;
			ce.observaciones_atiende=request.getParameter("p_observacion");
		}else
		{
			if(tipo_observacion==2)
			{
				ce.cve_persona_cancela=cve_persona;
				ce.observaciones_cancela=request.getParameter("p_observacion");
			}
			else
			{
				ce.cve_persona_atiende=0;
				ce.cve_persona_cancela=0;
				ce.observaciones_atiende=request.getParameter("p_observacion");
			}
		}
													
		ce.guardar_comentarios();			
		 
		if(ce.success_check!=1)
		{
			ce.cve_registro=0;
		}
		
		JSONObject json = new JSONObject();
		json.put("cve_registro", ce.cve_registro);
		out.print(json); 
 		out.flush(); 
}
catch (Exception exc)
{
	out.println("Revisa tu error--> "+exc);
}
}
%>
