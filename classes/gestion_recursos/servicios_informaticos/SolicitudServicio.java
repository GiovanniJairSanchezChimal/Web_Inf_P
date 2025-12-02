package gestion_recursos.servicios_informaticos;

import comun.BD;
import comun.e138;
import java.sql.ResultSet;

public class SolicitudServicio {
    private String strConsultas = "";
    public int Result = 0;
    public int folio = 0;
    public int anio = 0;
    public int cve_perzona_zoporte = 0;
    public int cve_usuario_gral = 0;
    public String mensaje;
    public String fecha_cancelacion = "";
    public String motivo_cancelacion = "";
    public String cve_zolizitante = "";
    public String mensaje_a;
    public String strCorreoPersonalSoporte = "";
    public String strNombreCompletoPersona;
    public String strCorreoInstitucional;
    public String correoPersonaSoprte = "";
    public String fpersona = "";
    public String strCorreoSolicitante = "";
    public String solSolicitante = "";
    public String solProblema = "";
    public String solFechaRegistro = "";
    public String strMotivoCancelacion;
    public String strConsultaSolicitante = "";
    public String strNombreSolicitante = "";
    public String strObservaciones = "";
    ResultSet rs;
    BD SMBD = new BD();
    e138 e = new e138();

    public SolicitudServicio() throws Exception {
    }

    public void azignazion_zolizitud() throws Exception {
        this.strConsultas = "UPDATE zolizitudez_trabajo SET fecha_azignazion = GETDATE(), cve_perzona_zoporte = " + this.cve_perzona_zoporte + " WHERE cve_zol = " + this.folio + " AND anio = " + this.anio + " AND fecha_azignazion IS NULL AND fecha_kanzelazion IS NULL";
        this.Result = this.SMBD.insertarSQL(this.strConsultas);
        if (this.cve_usuario_gral != 29213 && this.cve_usuario_gral != 29247) {
            this.enviaCorreoAsignacionSolicitud();
        }
    }

    
    public void kanzelar_zolizitudtrabajo() throws Exception {
        this.strConsultas = "UPDATE zolizitudez_trabajo SET fecha_kanzelazion = CONVERT (DATETIME,'" + this.fecha_cancelacion + "',103), motivo_kanzelazion = '" + this.motivo_cancelacion + "' WHERE cve_zol = " + this.folio + " AND anio = " + this.anio + " AND (fecha_kanzelazion IS NULL)";
        this.Result = this.SMBD.insertarSQL(this.strConsultas);
        if (this.cve_usuario_gral != 29213 && this.cve_usuario_gral != 29247) {
            this.DatosSolicitudSolicitante();
            this.enviaCorreoCancelacionSolicitud();
        }
    }

    public void actualizaOpciones() throws Exception {
        this.strConsultas = "UPDATE zolizitudez_trabajo set observaciones = '" + this.strObservaciones + "' WHERE cve_zol = " + this.folio + " AND anio = " + this.anio;
        this.Result = this.SMBD.insertarSQL(this.strConsultas);
        this.DatosSolicitudSolicitante();
        this.enviaCorreoObservacionesSolicitud();
    }

    public void enviaCorreoAsignacionSolicitud() throws Exception {
        this.e.encabezado = "ASIGNACIÓN DE SOLICITUD DE TRABAJO DE TI\n\n\n";
        this.mensaje_a = "<HTML><HEAD><meta http-equiv=''Content-Type'' content=''text/html; charset=UTF-8''></HEAD><BODY><TABLE><TR><TD><CENTER><B>ASIGNACIÓN DE SOLICITUD DE TRABAJO DE TI</B></CENTER></TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><B>Estimado (a):</B>&nbsp;&nbsp;" + this.SMBD.nombre_persona(this.cve_perzona_zoporte) + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>Le informamos que ha recibido una nueva solicitud de trabajo asignada por <I>" + this.SMBD.nombre_persona(this.cve_usuario_gral) + "</I>: </TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><B> Folio: </B> " + this.folio + "/" + this.anio + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><B> Fecha registro: </B>" + this.solFechaRegistro + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><B>Solicitante: </B> " + this.solSolicitante + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><B>Problema reportado: </B> " + this.solProblema + " </TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>Agradeceríamos su pronta atención a esta solicitud. Quedamos a la espera de sus acciones al respecto.</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><CENTER><B>Atentamente:</B></CENTER></TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><CENTER>Departamento de Tecnologías de la Información</CENTER></TD></TR></TABLE></HTML>";
        this.CorreoInstitucionalPersonalSoporte();
        String correoPerSopIT = this.strCorreoPersonalSoporte + "@utsjr.edu.mx";
        this.e.envioTI(this.mensaje_a, correoPerSopIT, this.e.encabezado);
    }


    public void enviaCorreoCancelacionSolicitud() throws Exception {
        this.e.encabezado = "CANCELACIÓN DE SOLICITUD DE TRABAJO DE TI\n\n\n";
        this.mensaje_a = "<HTML><HEAD><meta http-equiv=''Content-Type'' content=''text/html; charset=UTF-8''></HEAD><BODY><TABLE><TR><TD><CENTER><B>CANCELACIÓN DE SOLICITUD DE TRABAJO DE TI</B></CENTER></TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><B>Estimado (a):</B>" + this.strNombreSolicitante + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>Le informamos que su solicitud ha sido CANCELADA:</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><b>Folio:</b> " + this.folio + "/" + this.anio + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><b>Persona que cancela la solicitud: </b>" + this.SMBD.nombre_persona(this.cve_usuario_gral) + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><b>Motivo de cancelación</b>: " + this.motivo_cancelacion + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><CENTER><B>Atentamente:</B></CENTER></TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><CENTER>Departamento de Tecnologías de la Información</CENTER></TD></TR></TABLE></HTML>";
        this.CorreoInstitucionalDeSolicitante();
        String correoPerSoli = this.strCorreoSolicitante + "@utsjr.edu.mx";
        this.e.envioTI(this.mensaje_a, correoPerSoli, this.e.encabezado);
    }

    public void enviaCorreoObservacionesSolicitud() throws Exception {
        this.e.encabezado = "OBSERVACIONES DE SOLICITUD DE TRABAJO DE TI\n\n\n";
        this.mensaje_a = "<HTML><HEAD><meta http-equiv=''Content-Type'' content=''text/html; charset=UTF-8''></HEAD><BODY><TABLE><TR><TD><CENTER><B>OBSERVACIONES DE SOLICITUD DE TRABAJO DE TI</B></CENTER></TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><B>Estimado (a):</B>" + this.strNombreSolicitante + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>Le informamos que su solicitud:</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><b>Folio:</b> " + this.folio + "/" + this.anio + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>" + this.strObservaciones + "</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>Estaremos dando seguimiento para resolver su solicitud.</TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD>&nbsp;</TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><CENTER><B>Atentamente:</B></CENTER></TD></TR>";
        this.mensaje_a = this.mensaje_a + "<TR><TD><CENTER>Departamento de Tecnologías de la Información</CENTER></TD></TR></TABLE></HTML>";
        this.CorreoInstitucionalDeSolicitante();
        String correoPerSoli = this.strCorreoSolicitante + "@utsjr.edu.mx";
        this.e.envioTI(this.mensaje_a, correoPerSoli, this.e.encabezado);
    }

    public void CorreoInstitucionalPersonalSoporte() throws Exception {
        this.strConsultas = "SELECT corr30 FROM personal WHERE cve_persona = " + this.cve_perzona_zoporte;
        this.rs = this.SMBD.SQLBD2(this.strConsultas);
        while (this.rs.next()) {
            this.strCorreoPersonalSoporte = this.rs.getString(1);
        }
        this.SMBD.desconectarBD();
    }

    public void CorreoInstitucionalDeSolicitante() throws Exception {
        this.strConsultas = "SELECT p.corr30 FROM zolizitudez_trabajo z JOIN personal p ON p.cve_persona = z.cve_zolizitante WHERE z.cve_zol = " + this.folio + " AND z.anio = " + this.anio;
        this.rs = this.SMBD.SQLBD2(this.strConsultas);
        while (this.rs.next()) {
            this.strCorreoSolicitante = this.rs.getString(1);
        }
        this.SMBD.desconectarBD();
    }

    public void DatosSolicitudSolicitante() throws Exception {
        this.strConsultaSolicitante = "SELECT CONCAT(vp.nombre, ' ', vp.apellido_pat, ' ', vp.apellido_mat) AS nombre_completo FROM VPerzonalNombrez vp INNER JOIN zolizitudez_trabajo zot ON vp.cve_persona = zot.cve_zolizitante WHERE zot.cve_zol = " + this.folio + " AND zot.anio =" + this.anio;
        this.rs = this.SMBD.SQLBD2(this.strConsultaSolicitante);
        while (this.rs.next()) {
            this.strNombreSolicitante = this.rs.getString(1);
        }
        this.SMBD.desconectarBD();
    }

    public static void main(String[] args) throws Exception {
        new SolicitudServicio();
        System.out.println("KARY 07/06/2024 -- Se volvio a generar la clase");
    }
}
