```mermaid
erDiagram

        Size {
            TINY TINY
SMALL SMALL
MEDIUM MEDIUM
LARGE LARGE
HUGE HUGE
GARGANTUAN GARGANTUAN
        }
    


        Status {
            PENDING PENDING
PAID PAID
EXPIRED EXPIRED
CANCELLED CANCELLED
REFUNDED REFUNDED
        }
    
  "races" {
    String id "🗝️"
    String name 
    Int speed 
    Size size 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "subraces" {
    String id "🗝️"
    String name 
    String race_id 
    }
  

  "character_classes" {
    String id "🗝️"
    String name 
    Int hit_die 
    }
  

  "backgrounds" {
    String id "🗝️"
    String name 
    String description "❓"
    }
  

  "languages" {
    String id "🗝️"
    String name 
    }
  

  "characters" {
    String id "🗝️"
    String name 
    Int level 
    Int strength 
    Int dexterity 
    Int constitution 
    Int intelligence 
    Int wisdom 
    Int charisma 
    String user_id 
    String race_id 
    String subrace_id "❓"
    String character_class_id 
    String background_id 
    Boolean deleted 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "User" {
    String id "🗝️"
    String name 
    String email 
    String password 
    Boolean premium_active 
    DateTime premium_date "❓"
    Boolean deleted 
    DateTime created_at 
    DateTime updated_at 
    }
  

  "Payments" {
    String id "🗝️"
    String user_id 
    String external_payment 
    Status payment_status 
    }
  
    "races" |o--|| "Size" : "enum:size"
    "races" o{--}o "languages" : ""
    "subraces" }o--|| races : "race"
    "languages" o{--}o "characters" : ""
    "characters" }o--|| "User" : "user"
    "characters" }o--|| races : "race"
    "characters" }o--|o subraces : "subrace"
    "characters" }o--|| character_classes : "characterClass"
    "characters" }o--|| backgrounds : "background"
    "Payments" }o--|| "User" : "user"
    "Payments" |o--|| "Status" : "enum:payment_status"
```
