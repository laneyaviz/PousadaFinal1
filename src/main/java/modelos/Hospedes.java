package modelos;

public class Hospedes {
    private int idHospede;
    private String nome;
    private String telefone;
    private String email;
    private String senha;

    public Hospedes() {}

    public int getIdHospede() { return idHospede; }
    public void setIdHospede(int idHospede) { this.idHospede = idHospede; }
    
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }
    }
