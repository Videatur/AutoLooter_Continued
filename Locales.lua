-- The content of this file is AUTO-GENERATED
-- You can update it at https://www.curseforge.com/wow/addons/autolooter/localization

local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:NewLocale("AutoLooter", "enUS", true, true)
if L then
	L["(Legacy Types)"] = true
	L["Add item to alert list"] = true
	L["Add item to ignore list"] = true
	L["Add item to white list"] = true
	L["Added"] = true
	L["Alert List"] = true
	L["All"] = true
	L["All items received between this delay will be grouped"] = true
	L["Already in the list"] = true
	L["Auctionator"] = true
	L["Enable Auctionator integration for price checking"] = true
	L["Auto confirm loot roll"] = true
L["Blacklist"] = true
L["Close"] = true
L["Close after loot"] = true
L["Coin"] = true
L["Disabled"] = true
L["Don't loot anything while Fishing"] = true
L["Enable AutoLooter"] = true
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter will not loot anything when WoWs AutoLoot option is looting!

This allows you to use the WoWs AutoLoot key as way to enable/disable AutoLooter by target.

You can configure this options in 'Menu > Interface > Controls'.]=]
L["Enabled"] = true
L["Fast loot"] = true
L["Fishing"] = true
L["General"] = true
L["Hold and drag to move"] = true
L["Ignore BoP"] = true
L["Ignore Fishing"] = true
L["Ignore greys when looting by type"] = true
L["Ignored"] = true
L["Integration"] = true
L["Invalid item"] = true
L["Items list"] = true
L["Left-click"] = true
L["Listed"] = true
L["Load Profile"] = true
L["Load profile '${profile}' and reload UI?"] = true
L["Locked"] = true
L["Loot by Price"] = true
L["Loot by Rarity"] = true
L["Loot everything"] = true
L["Loot everything while Fishing"] = true
L["Loot everything with a price greater or equal to this value"] = true
L["Loot quest items"] = true
L["Not listed"] = true
L["Off"] = true
L["On"] = true
L["Price"] = true
L["Price (in coppers)"] = true
L["Print items others receive"] = true
L["Print items you receive"] = true
L["Printout chat frames"] = true
L["Printout commands at login"] = true
L["Printout items icon only"] = true
L["Printout items ignored"] = true
L["Printout items looted"] = true
L["Printout items type"] = true
L["Printout reason of loot"] = true
L["Quest"] = true
L["Rarity"] = true
L["Received Items"] = true
L["Received items group Delay (ms)"] = true
L["Remove all"] = true
L["Remove item from alert list"] = true
L["Remove item from ignore list"] = true
L["Remove item from white list"] = true
L["Remove old entries"] = true
L["Removed"] = true
L["Right-click"] = true
L["Right-click to show profile menu"] = true
L["Select all"] = true
L["Set alert sound"] = true
L["Show/Hide minimap button"] = true
L["Show/Hide UI"] = true
L["This can be useful to let addons like Fishing Buddy do its work"] = true
L["This will cleanup and recreate the type database"] = true
L["This will remove old types/subtypes entries from the database"] = true
L["to Enable/Disable loot all"] = true
L["to Show/Hide UI"] = true
L["Token"] = true
L["Try to show loot animation"] = true
L["Type"] = true
L["Whitelist"] = true
L["You"] = true
L["You can drag & drop items here!"] = true


	if GetLocale() == "enUS" or GetLocale() == "enGB" then
		return
	end
end

L = AceLocale:NewLocale("AutoLooter", "ptBR")
if L then
	L["(Legacy Types)"] = "(Tipos Legados)"
L["Add item to alert list"] = "Adiciona um item na lista de alertas"
L["Add item to ignore list"] = "Adiciona um item na lista de ignorados"
L["Add item to white list"] = "Adiciona um item na lista branca"
L["Added"] = "Adicionado"
L["Alert List"] = "Lista de Alertas"
L["All"] = "Tudo"
L["All items received between this delay will be grouped"] = "Todos os itens recebidos dentro deste intervalo serão agrupados"
L["Already in the list"] = "Já está na lista"
L["Auto confirm loot roll"] = "Confirmar automaticamente a rolagem de saque"
L["Blacklist"] = "Lista Negra"
L["Close"] = "Fechar"
L["Close after loot"] = "Fechar após saquear"
L["Coin"] = "Moeda"
L["Disabled"] = "Desligado"
L["Don't loot anything while Fishing"] = "Não saquear nada durante a pesca"
L["Enable AutoLooter"] = "Ativar AutoLooter"
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter não irá pegar nenhum item quando o Saque automático do WoW estiver funcionando!

Isso possibilita utilizar a tecla de saque para ativar/desativar o AutoLooter por alvo.

Você pode configurar essas opções em 'Menu > Interface > Controles'.]=]
L["Enabled"] = "Ativado"
L["Fast loot"] = "Saque rápido"
L["Fishing"] = "Pescaria"
L["General"] = "Geral"
L["Hold and drag to move"] = "Segure e arraste para mover"
L["Ignore BoP"] = "Ignorar BoP"
L["Ignore Fishing"] = "Ignorar pesca"
L["Ignore greys when looting by type"] = "Ignorar cinzas ao saquear por tipo"
L["Ignored"] = "Ignorado"
L["Integration"] = "Integração"
L["Invalid item"] = "Item inválido"
L["Items list"] = "Lista de itens"
L["Left-click"] = "Clique esquerdo"
L["Listed"] = "Na lista"
L["Load Profile"] = "Carregar perfil"
L["Load profile '${profile}' and reload UI?"] = "Carregar o perfil '${profile}' e recarregar a interface?"
L["Locked"] = "Bloqueado"
L["Loot by Price"] = "Saque por preço"
L["Loot by Rarity"] = "Saque por raridade"
L["Loot everything"] = "Saque tudo"
L["Loot everything while Fishing"] = "Saque tudo durante a pesca"
L["Loot everything with a price greater or equal to this value"] = "Saquear todos os itens com preço maior ou igual a este valor"
L["Loot quest items"] = "Saquear itens de missão"
L["Not listed"] = "Não listado"
L["Off"] = "Desligado"
L["On"] = "Ligado"
L["Price"] = "Preço"
L["Price (in coppers)"] = "Preço (em cobres)"
L["Print items others receive"] = "Mostrar os itens que outros recebem"
L["Print items you receive"] = "Mostrar os itens que você recebe"
L["Printout chat frames"] = "Janelas de chat para exibição"
L["Printout commands at login"] = "Exibir comandos durante o login"
L["Printout items icon only"] = "Exibir apenas o ícone dos itens"
L["Printout items ignored"] = "Escrever ignorados"
L["Printout items looted"] = "Mostrar itens saqueados"
L["Printout items type"] = "Mostrar o tipo dos itens"
L["Printout reason of loot"] = "Mostrar o motivo do saque"
L["Quest"] = "Missão"
L["Rarity"] = "Raridade"
L["Received Items"] = "Itens recebidos"
L["Received items group Delay (ms)"] = "Atraso para agrupar itens recebidos (ms)"
L["Remove all"] = "Remover todos"
L["Remove item from alert list"] = "Remove um item da lista de alertas"
L["Remove item from ignore list"] = "Remove um item da lista de ignorados"
L["Remove item from white list"] = "Remove um item da lista branca"
L["Remove old entries"] = "Remover registros antigos"
L["Removed"] = "Removido"
L["Right-click"] = "Clique direito"
L["Right-click to show profile menu"] = "Clique direito para mostrar o menu de perfil"
L["Select all"] = "Selecionar tudo"
L["Set alert sound"] = "Altera o som de alerta"
L["Show/Hide minimap button"] = "Mostrar/Ocultar o botão do minimapa"
L["Show/Hide UI"] = "Mostrar/Ocultar a interface"
L["This can be useful to let addons like Fishing Buddy do its work"] = "Isso pode ser útil para permitir que addons como o Fishing Buddy façam seu trabalho"
L["This will cleanup and recreate the type database"] = "Isso limpará e recriará o banco de dados de tipos"
L["This will remove old types/subtypes entries from the database"] = "Isso removerá entradas antigas de tipos/subtipos do banco de dados"
L["to Enable/Disable loot all"] = "para Ativar/Desativar 'saquear tudo'"
L["to Show/Hide UI"] = "para Mostrar/Ocultar a interface"
L["Token"] = "Ficha"
L["Try to show loot animation"] = "Tentar exibir a animação de saque"
L["Type"] = "Tipo"
L["Whitelist"] = "Whitelist"
L["You"] = "Você"
L["You can drag & drop items here!"] = "Você pode arrastar e soltar itens aqui!"


	return
end

L = AceLocale:NewLocale("AutoLooter", "frFR")
if L then
	L["(Legacy Types)"] = "(Types hérités)"
L["Add item to alert list"] = "Ajouter un objet à la Alert List"
L["Add item to ignore list"] = "Ajouter un objet à la ignore list"
L["Add item to white list"] = "Ajouter un objet à la white list"
L["Added"] = "Ajouté"
L["Alert List"] = "Alert List"
L["All"] = "Tout"
L["All items received between this delay will be grouped"] = "Tous les objets reçus pendant ce délai seront groupés"
L["Already in the list"] = "Déjà dans la liste"
L["Auto confirm loot roll"] = "Confirmer automatiquement les jets de butin"
L["Blacklist"] = "Blacklist"
L["Close"] = "Fermer"
L["Close after loot"] = "Fermer après le butin"
L["Coin"] = "Pièce"
L["Disabled"] = "Désactivé"
L["Don't loot anything while Fishing"] = "Ne rien ramasser pendant la pêche"
L["Enable AutoLooter"] = "Activer AutoLooter"
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter ne ramassera rien lorsque l’option de Butin automatique de WoW effectue le butin !

Ceci vous permet d’utiliser la touche de Butin automatique pour activer/désactiver AutoLooter selon la cible.

Vous pouvez configurer ces options dans « Menu > Interface > Commandes ».]=]
L["Enabled"] = "Activé"
L["Fast loot"] = "Butin rapide"
L["Fishing"] = "Pêche"
L["General"] = "Général"
L["Hold and drag to move"] = "Maintenez et faites glisser pour déplacer"
L["Ignore BoP"] = "Ignorer BoP"
L["Ignore Fishing"] = "Ignorer la pêche"
L["Ignore greys when looting by type"] = "Ignorer les objets gris lors du butin par type"
L["Ignored"] = "Ignoré"
L["Integration"] = "Intégration"
L["Invalid item"] = "Objet invalide"
L["Items list"] = "Liste des objets"
L["Left-click"] = "Clic gauche"
L["Listed"] = "Listé"
L["Load Profile"] = "Charger le profil"
L["Load profile '${profile}' and reload UI?"] = "Charger le profil « ${profile} » et recharger l’interface ?"
L["Locked"] = "Verrouillé"
L["Loot by Price"] = "Butin par prix"
L["Loot by Rarity"] = "Butin par rareté"
L["Loot everything"] = "Tout ramasser"
L["Loot everything while Fishing"] = "Tout ramasser pendant la pêche"
L["Loot everything with a price greater or equal to this value"] = "Ramasser tout objet d’un prix supérieur ou égal à cette valeur"
L["Loot quest items"] = "Ramasser les objets de quête"
L["Not listed"] = "Non listé"
L["Off"] = "Désactivé"
L["On"] = "Activé"
L["Price"] = "Prix"
L["Price (in coppers)"] = "Prix (en cuivres)"
L["Print items others receive"] = "Afficher les objets reçus par les autres"
L["Print items you receive"] = "Afficher les objets que vous recevez"
L["Printout chat frames"] = "Fenêtres de chat pour l’affichage"
L["Printout commands at login"] = "Afficher les commandes à la connexion"
L["Printout items icon only"] = "N’afficher que l’icône des objets"
L["Printout items ignored"] = "Afficher les objets ignorés"
L["Printout items looted"] = "Afficher les objets ramassés"
L["Printout items type"] = "Afficher le type d’objets"
L["Printout reason of loot"] = "Afficher la raison du butin"
L["Quest"] = "Quête"
L["Rarity"] = "Rareté"
L["Received Items"] = "Objets reçus"
L["Received items group Delay (ms)"] = "Délai de regroupement des objets reçus (ms)"
L["Remove all"] = "Tout supprimer"
L["Remove item from alert list"] = "Retirer un objet de la Alert List"
L["Remove item from ignore list"] = "Retirer un objet de la ignore list"
L["Remove item from white list"] = "Retirer un objet de la white list"
L["Remove old entries"] = "Supprimer les anciennes entrées"
L["Removed"] = "Supprimé"
L["Right-click"] = "Clic droit"
L["Right-click to show profile menu"] = "Clic droit pour afficher le menu du profil"
L["Select all"] = "Tout sélectionner"
L["Set alert sound"] = "Définir le son d’alerte"
L["Show/Hide minimap button"] = "Afficher/Masquer le bouton de la minicarte"
L["Show/Hide UI"] = "Afficher/Masquer l’interface"
L["This can be useful to let addons like Fishing Buddy do its work"] = "Utile pour laisser des addons comme Fishing Buddy faire leur travail"
L["This will cleanup and recreate the type database"] = "Ceci va nettoyer et recréer la base de données des types"
L["This will remove old types/subtypes entries from the database"] = "Ceci va supprimer les anciennes entrées de types/sous‑types de la base de données"
L["to Enable/Disable loot all"] = "pour Activer/Désactiver ‘tout ramasser’"
L["to Show/Hide UI"] = "pour Afficher/Masquer l’interface"
L["Token"] = "Jeton"
L["Try to show loot animation"] = "Essayer d’afficher l’animation de butin"
L["Type"] = "Type"
L["Whitelist"] = "Whitelist"
L["You"] = "Vous"
L["You can drag & drop items here!"] = "Vous pouvez glisser‑déposer des objets ici !"

	return
end

L = AceLocale:NewLocale("AutoLooter", "deDE")
if L then
	L["(Legacy Types)"] = "(Veraltete Typen)"
L["Add item to alert list"] = "Gegenstand zur Alert List hinzufügen"
L["Add item to ignore list"] = "Gegenstand zur ignore list hinzufügen"
L["Add item to white list"] = "Gegenstand zur white list hinzufügen"
L["Added"] = "Hinzugefügt"
L["Alert List"] = "Alert List"
L["All"] = "Alle"
L["All items received between this delay will be grouped"] = "Alle innerhalb dieser Verzögerung erhaltenen Gegenstände werden gruppiert"
L["Already in the list"] = "Bereits in der Liste"
L["Auto confirm loot roll"] = "Beutewurf automatisch bestätigen"
L["Blacklist"] = "Blacklist"
L["Close"] = "Schließen"
L["Close after loot"] = "Nach dem Plündern schließen"
L["Coin"] = "Münze"
L["Disabled"] = "Deaktiviert"
L["Don't loot anything while Fishing"] = "Beim Angeln nichts plündern"
L["Enable AutoLooter"] = "AutoLooter aktivieren"
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter plündert nichts, wenn die WoW‑Option "Autom. Plündern" aktiv ist!

Dadurch kannst du die Taste für das automatische Plündern nutzen, um AutoLooter je nach Ziel ein-/auszuschalten.

Du kannst diese Optionen unter "Menü > Interface > Steuerung" konfigurieren.]=]
L["Enabled"] = "Aktiviert"
L["Fast loot"] = "Schnelles Plündern"
L["Fishing"] = "Angeln"
L["General"] = "Allgemein"
L["Hold and drag to move"] = "Zum Verschieben halten und ziehen"
L["Ignore BoP"] = "BoP ignorieren"
L["Ignore Fishing"] = "Angeln ignorieren"
L["Ignore greys when looting by type"] = "Graue Gegenstände beim Plündern nach Typ ignorieren"
L["Ignored"] = "Ignoriert"
L["Integration"] = "Integration"
L["Invalid item"] = "Ungültiger Gegenstand"
L["Items list"] = "Gegenstandsliste"
L["Left-click"] = "Linksklick"
L["Listed"] = "Aufgelistet"
L["Load Profile"] = "Profil laden"
L["Load profile '${profile}' and reload UI?"] = "Profil \"${profile}\" laden und UI neu laden?"
L["Locked"] = "Gesperrt"
L["Loot by Price"] = "Beute nach Preis"
L["Loot by Rarity"] = "Beute nach Seltenheit"
L["Loot everything"] = "Alles plündern"
L["Loot everything while Fishing"] = "Beim Angeln alles plündern"
L["Loot everything with a price greater or equal to this value"] = "Alles plündern, dessen Preis größer oder gleich diesem Wert ist"
L["Loot quest items"] = "Questgegenstände plündern"
L["Not listed"] = "Nicht in der Liste"
L["Off"] = "Aus"
L["On"] = "An"
L["Price"] = "Preis"
L["Price (in coppers)"] = "Preis (in Kupfer)"
L["Print items others receive"] = "Gegenstände anzeigen, die andere erhalten"
L["Print items you receive"] = "Gegenstände anzeigen, die du erhältst"
L["Printout chat frames"] = "Chatfenster für die Ausgabe"
L["Printout commands at login"] = "Befehle beim Login anzeigen"
L["Printout items icon only"] = "Nur das Gegenstandssymbol anzeigen"
L["Printout items ignored"] = "Ignorierte Gegenstände anzeigen"
L["Printout items looted"] = "Geplünderte Gegenstände anzeigen"
L["Printout items type"] = "Gegenstandstyp anzeigen"
L["Printout reason of loot"] = "Grund für die Beute anzeigen"
L["Quest"] = "Quest"
L["Rarity"] = "Seltenheit"
L["Received Items"] = "Erhaltene Gegenstände"
L["Received items group Delay (ms)"] = "Verzögerung zum Gruppieren erhaltener Gegenstände (ms)"
L["Remove all"] = "Alle entfernen"
L["Remove item from alert list"] = "Gegenstand aus der Alert List entfernen"
L["Remove item from ignore list"] = "Gegenstand aus der ignore list entfernen"
L["Remove item from white list"] = "Gegenstand aus der white list entfernen"
L["Remove old entries"] = "Alte Einträge entfernen"
L["Removed"] = "Entfernt"
L["Right-click"] = "Rechtsklick"
L["Right-click to show profile menu"] = "Rechtsklick, um das Profilmenü zu öffnen"
L["Select all"] = "Alle auswählen"
L["Set alert sound"] = "Warnton festlegen"
L["Show/Hide minimap button"] = "Minimap-Schaltfläche anzeigen/ausblenden"
L["Show/Hide UI"] = "UI anzeigen/ausblenden"
L["This can be useful to let addons like Fishing Buddy do its work"] = "Nützlich, damit Addons wie Fishing Buddy ihre Arbeit machen können"
L["This will cleanup and recreate the type database"] = "Dies bereinigt und erstellt die Typdatenbank neu"
L["This will remove old types/subtypes entries from the database"] = "Dies entfernt alte Typen/Untertypen aus der Datenbank"
L["to Enable/Disable loot all"] = "zum Aktivieren/Deaktivieren von \"Alles plündern\""
L["to Show/Hide UI"] = "zum Anzeigen/Ausblenden der UI"
L["Token"] = "Abzeichen"
L["Try to show loot animation"] = "Versuchen, die Beuteanimation anzuzeigen"
L["Type"] = "Typ"
L["Whitelist"] = "Whitelist"
L["You"] = "Du"
L["You can drag & drop items here!"] = "Du kannst Gegenstände hierher ziehen und ablegen!"

	return
end

L = AceLocale:NewLocale("AutoLooter", "itIT")
if L then
	L["(Legacy Types)"] = "(Tipi legacy)"
L["Add item to alert list"] = "Aggiungi oggetto alla Alert List"
L["Add item to ignore list"] = "Aggiungi oggetto alla ignore list"
L["Add item to white list"] = "Aggiungi oggetto alla white list"
L["Added"] = "Aggiunto"
L["Alert List"] = "Alert List"
L["All"] = "Tutto"
L["All items received between this delay will be grouped"] = "Tutti gli oggetti ricevuti entro questo intervallo saranno raggruppati"
L["Auctionator"] = "Integrazione Auctionator"
L["Enable Auctionator integration for price checking"] = "Abilita l'integrazione con Auctionator per il controllo dei prezzi"
L["Already in the list"] = "Già nella lista"
L["Auto confirm loot roll"] = "Conferma automatica al roll del Loot"
L["Blacklist"] = "Blacklist"
L["Close"] = "Chiudi"
L["Close after loot"] = "Chiudi dopo aver raccolto"
L["Coin"] = "Moneta"
L["Disabled"] = "Disabilitato"
L["Don't loot anything while Fishing"] = "Non raccogliere durante la pesca"
L["Enable AutoLooter"] = "Abilita AutoLooter"
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter non raccoglierà quando l’opzione di Loot Automatico di WoW è attiva!

Questo ti permette di usare il tasto del Loot automatico per abilitare/disabilitare AutoLooter in base al target.

Puoi configurare queste opzioni in "Menu > Interfaccia > Comandi".]=]
L["Enabled"] = "Abilitato"
L["Fast loot"] = "Loot rapido"
L["Fishing"] = "Pesca"
L["General"] = "Generale"
L["Hold and drag to move"] = "Tieni premuto e trascina per spostare"
L["Ignore BoP"] = "Ignora BoP"
L["Ignore Fishing"] = "Ignora pesca"
L["Ignore greys when looting by type"] = "Ignora i grigi durante il Loot per tipo"
L["Ignored"] = "Ignorato"
L["Integration"] = "Integrazione"
L["Invalid item"] = "Oggetto non valido"
L["Items list"] = "Lista oggetti"
L["Left-click"] = "Clic sinistro"
L["Listed"] = "In lista"
L["Load Profile"] = "Carica profilo"
L["Load profile '${profile}' and reload UI?"] = "Caricare il profilo '${profile}' e ricaricare l’interfaccia?"
L["Locked"] = "Bloccato"
L["Loot by Price"] = "Raccogli per prezzo"
L["Loot by Rarity"] = "Raccogli per rarità"
L["Loot everything"] = "Raccogli tutto"
L["Loot everything while Fishing"] = "Raccogli tutto durante la pesca"
L["Loot everything with a price greater or equal to this value"] = "Raccogli oggetti con prezzo maggiore o uguale a questo valore"
L["Loot quest items"] = "Raccogli oggetti di missione"
L["Not listed"] = "Non in lista"
L["Off"] = "Off"
L["On"] = "On"
L["Price"] = "Prezzo"
L["Price (in coppers)"] = "Prezzo (in copper)"
L["Print items others receive"] = "Mostra gli oggetti che ricevono gli altri"
L["Print items you receive"] = "Mostra gli oggetti che ricevi"
L["Printout chat frames"] = "Finestre di chat dove sarà mostrato"
L["Printout commands at login"] = "Mostra comandi all’accesso"
L["Printout items icon only"] = "Mostra solo l’icona degli oggetti"
L["Printout items ignored"] = "Mostra oggetti ignorati"
L["Printout items looted"] = "Mostra oggetti raccolti"
L["Printout items type"] = "Mostra tipo oggetti"
L["Printout reason of loot"] = "Mostra il motivo del loot"
L["Quest"] = "Missione"
L["Rarity"] = "Rarità"
L["Received Items"] = "Oggetti ricevuti"
L["Received items group Delay (ms)"] = "Ritardo raggruppamento oggetti ricevuti (ms)"
L["Remove all"] = "Rimuovi tutto"
L["Remove item from alert list"] = "Rimuovi oggetto dalla Alert List"
L["Remove item from ignore list"] = "Rimuovi oggetto dalla ignore list"
L["Remove item from white list"] = "Rimuovi oggetto dalla white list"
L["Remove old entries"] = "Rimuovi voci obsolete"
L["Removed"] = "Rimosso"
L["Right-click"] = "Clic destro"
L["Right-click to show profile menu"] = "Clic destro per mostrare il menu profilo"
L["Select all"] = "Seleziona tutto"
L["Set alert sound"] = "Imposta suono di avviso"
L["Show/Hide minimap button"] = "Mostra/Nascondi pulsante sulla minimappa"
L["Show/Hide UI"] = "Mostra/Nascondi UI"
L["This can be useful to let addons like Fishing Buddy do its work"] = "Utile per lasciare che addon come Fishing Buddy facciano il loro lavoro"
L["This will cleanup and recreate the type database"] = "Questo pulirà e ricreerà il database dei tipi"
L["This will remove old types/subtypes entries from the database"] = "Questo rimuoverà vecchie voci di tipi/sottotipi dal database"
L["to Enable/Disable loot all"] = "per Abilitare/Disabilitare il raccogliere tutto"
L["to Show/Hide UI"] = "per Mostrare/Nascondere la UI"
L["Token"] = "Gettone"
L["Try to show loot animation"] = "Prova a mostrare l’animazione di Loot"
L["Type"] = "Tipo"
L["Whitelist"] = "Whitelist"
L["You"] = "Tu"
L["You can drag & drop items here!"] = "Puoi trascinare e rilasciare gli oggetti qui!"

	return
end

L = AceLocale:NewLocale("AutoLooter", "esES")
if L then
	L["(Legacy Types)"] = "(Tipos heredados)"
L["Add item to alert list"] = "Añadir objeto a la Alert List"
L["Add item to ignore list"] = "Añadir objeto a la ignore list"
L["Add item to white list"] = "Añadir objeto a la white list"
L["Added"] = "Añadido"
L["Alert List"] = "Alert List"
L["All"] = "Todo"
L["All items received between this delay will be grouped"] = "Todos los objetos recibidos durante este intervalo se agruparán"
L["Already in the list"] = "Ya está en la lista"
L["Auto confirm loot roll"] = "Confirmar automáticamente el botín"
L["Blacklist"] = "Blacklist"
L["Close"] = "Cerrar"
L["Close after loot"] = "Cerrar después de saquear"
L["Coin"] = "Moneda"
L["Disabled"] = "Desactivado"
L["Don't loot anything while Fishing"] = "No saquear nada durante la pesca"
L["Enable AutoLooter"] = "Habilitar AutoLooter"
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter no saqueará nada cuando la opción de Saqueo automático de WoW esté activa.

Esto te permite usar la tecla de Saqueo automático para activar o desactivar AutoLooter según el objetivo.

Puedes configurar estas opciones en « Menú > Interfaz > Controles ».]=]
L["Enabled"] = "Activado"
L["Fast loot"] = "Botín rápido"
L["Fishing"] = "Pesca"
L["General"] = "General"
L["Hold and drag to move"] = "Mantén y arrastra para mover"
L["Ignore BoP"] = "Ignorar BoP"
L["Ignore Fishing"] = "Ignorar pesca"
L["Ignore greys when looting by type"] = "Ignorar los grises al saquear por tipo"
L["Ignored"] = "Ignorado"
L["Integration"] = "Integración"
L["Invalid item"] = "Objeto no válido"
L["Items list"] = "Lista de objetos"
L["Left-click"] = "Clic izquierdo"
L["Listed"] = "Listado"
L["Load Profile"] = "Cargar perfil"
L["Load profile '${profile}' and reload UI?"] = "¿Cargar el perfil « ${profile} » y recargar la interfaz?"
L["Locked"] = "Bloqueado"
L["Loot by Price"] = "Saquear por precio"
L["Loot by Rarity"] = "Saquear por rareza"
L["Loot everything"] = "Saqueo todo"
L["Loot everything while Fishing"] = "Saqueo todo durante la pesca"
L["Loot everything with a price greater or equal to this value"] = "Saquear todo objeto con precio mayor o igual a este valor"
L["Loot quest items"] = "Saquear objetos de misión"
L["Not listed"] = "No listado"
L["Off"] = "Apagado"
L["On"] = "Encendido"
L["Price"] = "Precio"
L["Price (in coppers)"] = "Precio (en cobres)"
L["Print items others receive"] = "Mostrar los objetos que reciben otros"
L["Print items you receive"] = "Mostrar los objetos que recibes"
L["Printout chat frames"] = "Ventanas de chat para mostrar"
L["Printout commands at login"] = "Mostrar comandos al iniciar sesión"
L["Printout items icon only"] = "Mostrar solo el icono de los objetos"
L["Printout items ignored"] = "Mostrar objetos ignorados"
L["Printout items looted"] = "Mostrar objetos saqueados"
L["Printout items type"] = "Mostrar el tipo de objetos"
L["Printout reason of loot"] = "Mostrar el motivo del botín"
L["Quest"] = "Misión"
L["Rarity"] = "Rareza"
L["Received Items"] = "Objetos recibidos"
L["Received items group Delay (ms)"] = "Retraso para agrupar objetos recibidos (ms)"
L["Remove all"] = "Eliminar todo"
L["Remove item from alert list"] = "Eliminar objeto de la Alert List"
L["Remove item from ignore list"] = "Eliminar objeto de la ignore list"
L["Remove item from white list"] = "Eliminar objeto de la white list"
L["Remove old entries"] = "Eliminar entradas antiguas"
L["Removed"] = "Eliminado"
L["Right-click"] = "Clic derecho"
L["Right-click to show profile menu"] = "Clic derecho para mostrar el menú de perfil"
L["Select all"] = "Seleccionar todo"
L["Set alert sound"] = "Configurar sonido de alerta"
L["Show/Hide minimap button"] = "Mostrar/Ocultar el botón del minimapa"
L["Show/Hide UI"] = "Mostrar/Ocultar la interfaz"
L["This can be useful to let addons like Fishing Buddy do its work"] = "Puede ser útil para que addons como Fishing Buddy hagan su trabajo"
L["This will cleanup and recreate the type database"] = "Esto limpiará y recreará la base de datos de tipos"
L["This will remove old types/subtypes entries from the database"] = "Esto eliminará las entradas antiguas de tipos/subtipos de la base de datos"
L["to Enable/Disable loot all"] = "para activar/desactivar ‘saquear todo’"
L["to Show/Hide UI"] = "para mostrar/ocultar la interfaz"
L["Token"] = "Ficha"
L["Try to show loot animation"] = "Intentar mostrar la animación de botín"
L["Type"] = "Tipo"
L["Whitelist"] = "Whitelist"
L["You"] = "Tú"
L["You can drag & drop items here!"] = "¡Puedes arrastrar y soltar objetos aquí!"

	return
end

L = AceLocale:NewLocale("AutoLooter", "esMX")
if L then
	--[[Translation missing --]]
L["(Legacy Types)"] = "(Legacy Types)"
L["Add item to alert list"] = "Agregar objeto a la lista de alertas"
L["Add item to ignore list"] = "Agregar objeto a la lista de ignorados"
L["Add item to white list"] = "Agregar objeto a la lista blanca"
L["Added"] = "Agregar"
L["Alert List"] = "Lista de alertas"
L["All"] = "Todo"
--[[Translation missing --]]
L["All items received between this delay will be grouped"] = "All items received between this delay will be grouped"
L["Already in the list"] = "Ya se encuentra en la lista"
L["Auto confirm loot roll"] = "Confirmar automáticamente el botín"
L["Blacklist"] = "Lista Negra"
L["Close"] = "Cerrar"
L["Close after loot"] = "Cerrar después del botín"
--[[Translation missing --]]
L["Coin"] = "Coin"
L["Disabled"] = "Deshabilitado"
--[[Translation missing --]]
L["Don't loot anything while Fishing"] = "Don't loot anything while Fishing"
L["Enable AutoLooter"] = "Habilitar AutoLooter"
--[[Translation missing --]]
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter will not loot anything when WoWs AutoLoot option is looting!

This allows you to use the WoWs AutoLoot key as way to enable/disable AutoLooter by target.

You can configure this options in 'Menu > Interface > Controls'.]=]
L["Enabled"] = "Habilitado"
--[[Translation missing --]]
L["Fast loot"] = "Fast loot"
--[[Translation missing --]]
L["Fishing"] = "Fishing"
L["General"] = "General"
L["Hold and drag to move"] = "Sostenga y arrastre para mover"
--[[Translation missing --]]
L["Ignore BoP"] = "Ignore BoP"
--[[Translation missing --]]
L["Ignore Fishing"] = "Ignore Fishing"
--[[Translation missing --]]
L["Ignore greys when looting by type"] = "Ignore greys when looting by type"
L["Ignored"] = "Ignorar"
--[[Translation missing --]]
L["Integration"] = "Integration"
L["Invalid item"] = "Objeto Invalido"
L["Items list"] = "Lista de objetos"
L["Left-click"] = "Click izquierdo"
L["Listed"] = "Listado"
--[[Translation missing --]]
L["Load Profile"] = "Load Profile"
--[[Translation missing --]]
L["Load profile '${profile}' and reload UI?"] = "Load profile '${profile}' and reload UI?"
L["Locked"] = "Cerrado"
L["Loot by Price"] = "Recolectar por precio"
L["Loot by Rarity"] = "Recolectar por rareza"
L["Loot everything"] = "Recolectar todo"
--[[Translation missing --]]
L["Loot everything while Fishing"] = "Loot everything while Fishing"
--[[Translation missing --]]
L["Loot everything with a price greater or equal to this value"] = "Loot everything with a price greater or equal to this value"
L["Loot quest items"] = "Recolectar objetos de misión"
L["Not listed"] = "No enlistado"
L["Off"] = "Apagar"
L["On"] = "Encender"
L["Price"] = "Precio"
--[[Translation missing --]]
L["Price (in coppers)"] = "Price (in coppers)"
--[[Translation missing --]]
L["Print items others receive"] = "Print items others receive"
--[[Translation missing --]]
L["Print items you receive"] = "Print items you receive"
--[[Translation missing --]]
L["Printout chat frames"] = "Printout chat frames"
--[[Translation missing --]]
L["Printout commands at login"] = "Printout commands at login"
--[[Translation missing --]]
L["Printout items icon only"] = "Printout items icon only"
--[[Translation missing --]]
L["Printout items ignored"] = "Printout items ignored"
--[[Translation missing --]]
L["Printout items looted"] = "Printout items looted"
--[[Translation missing --]]
L["Printout items type"] = "Printout items type"
--[[Translation missing --]]
L["Printout reason of loot"] = "Printout reason of loot"
--[[Translation missing --]]
L["Quest"] = "Quest"
--[[Translation missing --]]
L["Rarity"] = "Rarity"
--[[Translation missing --]]
L["Received Items"] = "Received Items"
--[[Translation missing --]]
L["Received items group Delay (ms)"] = "Received items group Delay (ms)"
--[[Translation missing --]]
L["Remove all"] = "Remove all"
--[[Translation missing --]]
L["Remove item from alert list"] = "Remove item from alert list"
--[[Translation missing --]]
L["Remove item from ignore list"] = "Remove item from ignore list"
--[[Translation missing --]]
L["Remove item from white list"] = "Remove item from white list"
--[[Translation missing --]]
L["Remove old entries"] = "Remove old entries"
--[[Translation missing --]]
L["Removed"] = "Removed"
--[[Translation missing --]]
L["Right-click"] = "Right-click"
--[[Translation missing --]]
L["Right-click to show profile menu"] = "Right-click to show profile menu"
--[[Translation missing --]]
L["Select all"] = "Select all"
--[[Translation missing --]]
L["Set alert sound"] = "Set alert sound"
--[[Translation missing --]]
L["Show/Hide minimap button"] = "Show/Hide minimap button"
--[[Translation missing --]]
L["Show/Hide UI"] = "Show/Hide UI"
--[[Translation missing --]]
L["This can be useful to let addons like Fishing Buddy do its work"] = "This can be useful to let addons like Fishing Buddy do its work"
--[[Translation missing --]]
L["This will cleanup and recreate the type database"] = "This will cleanup and recreate the type database"
--[[Translation missing --]]
L["This will remove old types/subtypes entries from the database"] = "This will remove old types/subtypes entries from the database"
--[[Translation missing --]]
L["to Enable/Disable loot all"] = "to Enable/Disable loot all"
--[[Translation missing --]]
L["to Show/Hide UI"] = "to Show/Hide UI"
--[[Translation missing --]]
L["Token"] = "Token"
--[[Translation missing --]]
L["Try to show loot animation"] = "Try to show loot animation"
--[[Translation missing --]]
L["Type"] = "Type"
--[[Translation missing --]]
L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
L["You"] = "You"
--[[Translation missing --]]
L["You can drag & drop items here!"] = "You can drag & drop items here!"

	return
end

L = AceLocale:NewLocale("AutoLooter", "ruRU")
if L then
	L["(Legacy Types)"] = "(Устаревшие типы)"
L["Add item to alert list"] = "Добавить предмет в список уведомлений"
L["Add item to ignore list"] = "Добавить предмет в черный список"
L["Add item to white list"] = "Добавить предмет в белый список"
L["Added"] = "Добавлено"
L["Alert List"] = "Список уведомлений"
L["All"] = "Всё"
L["All items received between this delay will be grouped"] = "Все полученные за указанный период предметы будут сгруппированы"
L["Already in the list"] = "Уже в списке"
L["Auto confirm loot roll"] = "Автоподтверждение ролла"
L["Blacklist"] = "Черный список"
L["Close"] = "Закрыть"
L["Close after loot"] = "Закрыть после сбора"
L["Coin"] = "Деньги"
L["Disabled"] = "Отключено"
L["Don't loot anything while Fishing"] = "Не собирать во время рыбалки"
L["Enable AutoLooter"] = "Включить AutoLooter"
L["ENABLE_AUTO_LOOTER_DESC"] = "AutoLooter не будет ничего собирать, если WoW собирает своей встроенной функцией! Это позволяет использовать клавишу автосбора как способ включения/выключения AutoLooter от цели к цели. Эти настройки можно изменить в \"Меню\" -> \"Интерфейс\" -> \"Управление\"."
L["Enabled"] = "Включено"
L["Fast loot"] = "Быстрый сбор"
L["Fishing"] = "Рыбалка"
L["General"] = "Общие настройки"
L["Hold and drag to move"] = "Удерживай и тащи, чтобы перемещать"
L["Ignore BoP"] = "Игнорировать BoP"
L["Ignore Fishing"] = "Игнорировать рыбалку"
L["Ignore greys when looting by type"] = "Игнорировать мусор при сборе по типу"
L["Ignored"] = "Игнорируется"
L["Integration"] = "Интеграция"
L["Invalid item"] = "Неверный предмет"
L["Items list"] = "Список предметов"
L["Left-click"] = "Левый щелчок"
L["Listed"] = "Внесено в список"
L["Load Profile"] = "Загрузить профиль"
L["Load profile '${profile}' and reload UI?"] = "Загрузить профиль '${profile}' и перезагрузить интерфейс?"
L["Locked"] = "Заблокировано"
L["Loot by Price"] = "Сбор по цене"
L["Loot by Rarity"] = "Сбор по редкости"
L["Loot everything"] = "Собирать всё"
L["Loot everything while Fishing"] = "Собирать всё во время рыбалки"
L["Loot everything with a price greater or equal to this value"] = "Собирать всё, что дороже указанной стоимости"
L["Loot quest items"] = "Собирать квестовые предметы"
L["Not listed"] = "Не внесено в список"
L["Off"] = "Выключено"
L["On"] = "Включено"
L["Price"] = "Цена"
L["Price (in coppers)"] = "Цена (в медных монетах)"
L["Print items others receive"] = "Выводить предметы, которые собирают другие"
L["Print items you receive"] = "Выводить предметы, которые собираете вы."
L["Printout chat frames"] = "Окна чата для отображения"
L["Printout commands at login"] = "Выводить команды при входе"
L["Printout items icon only"] = "Показывать только иконку предмета"
L["Printout items ignored"] = "Показывать проигнорированные предметы"
L["Printout items looted"] = "Показывать собранные предметы"
L["Printout items type"] = "Показывать тип предметов"
L["Printout reason of loot"] = "Показывать причину сбора"
L["Quest"] = "Квестовые"
L["Rarity"] = "Редкость"
L["Received Items"] = "Полученные предметы"
L["Received items group Delay (ms)"] = "Задержка для предметов, полученных группой (мс)"
L["Remove all"] = "Удалить всё"
L["Remove item from alert list"] = "Удалить предмет из списка уведомлений"
L["Remove item from ignore list"] = "Удалить предмет из черного списка"
L["Remove item from white list"] = "Удалить предмет из белого списка"
L["Remove old entries"] = "Удалить старые данные"
L["Removed"] = "Удалено"
L["Right-click"] = "Правый щелчок"
L["Right-click to show profile menu"] = "ПКМ чтобы показать меню профиля"
L["Select all"] = "Выбрать всё"
L["Set alert sound"] = "Выбрать звук уведомления"
L["Show/Hide minimap button"] = "Показать/скрыть иконку у миникарты"
L["Show/Hide UI"] = "Показать/скрыть интерфейс"
L["This can be useful to let addons like Fishing Buddy do its work"] = "Может быть полезно для Fishing Buddy и подобных дополнений."
L["This will cleanup and recreate the type database"] = "Это очистит и пересоздаст базу данных."
L["This will remove old types/subtypes entries from the database"] = "Это удалит старые типы/подтипы из базы данных."
L["to Enable/Disable loot all"] = ": включить/выключить сбор всего"
L["to Show/Hide UI"] = ": скрыть/показать интерфейс"
L["Token"] = "Токен"
L["Try to show loot animation"] = "Показывать анимацию сбора"
L["Type"] = "Тип"
L["Whitelist"] = "Whitelist"
L["You"] = "Вы"
L["You can drag & drop items here!"] = "Сюда можно перетаскивать предметы!"

	return
end

L = AceLocale:NewLocale("AutoLooter", "koKR")
if L then
	--[[Translation missing --]]
L["(Legacy Types)"] = "(Legacy Types)"
--[[Translation missing --]]
L["Add item to alert list"] = "Add item to alert list"
--[[Translation missing --]]
L["Add item to ignore list"] = "Add item to ignore list"
--[[Translation missing --]]
L["Add item to white list"] = "Add item to white list"
--[[Translation missing --]]
L["Added"] = "Added"
--[[Translation missing --]]
L["Alert List"] = "Alert List"
--[[Translation missing --]]
L["All"] = "All"
--[[Translation missing --]]
L["All items received between this delay will be grouped"] = "All items received between this delay will be grouped"
--[[Translation missing --]]
L["Already in the list"] = "Already in the list"
--[[Translation missing --]]
L["Auto confirm loot roll"] = "Auto confirm loot roll"
--[[Translation missing --]]
L["Blacklist"] = "Blacklist"
--[[Translation missing --]]
L["Close"] = "Close"
--[[Translation missing --]]
L["Close after loot"] = "Close after loot"
--[[Translation missing --]]
L["Coin"] = "Coin"
--[[Translation missing --]]
L["Disabled"] = "Disabled"
--[[Translation missing --]]
L["Don't loot anything while Fishing"] = "Don't loot anything while Fishing"
--[[Translation missing --]]
L["Enable AutoLooter"] = "Enable AutoLooter"
--[[Translation missing --]]
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter will not loot anything when WoWs AutoLoot option is looting!

This allows you to use the WoWs AutoLoot key as way to enable/disable AutoLooter by target.

You can configure this options in 'Menu > Interface > Controls'.]=]
--[[Translation missing --]]
L["Enabled"] = "Enabled"
--[[Translation missing --]]
L["Fast loot"] = "Fast loot"
--[[Translation missing --]]
L["Fishing"] = "Fishing"
--[[Translation missing --]]
L["General"] = "General"
--[[Translation missing --]]
L["Hold and drag to move"] = "Hold and drag to move"
--[[Translation missing --]]
L["Ignore BoP"] = "Ignore BoP"
--[[Translation missing --]]
L["Ignore Fishing"] = "Ignore Fishing"
--[[Translation missing --]]
L["Ignore greys when looting by type"] = "Ignore greys when looting by type"
--[[Translation missing --]]
L["Ignored"] = "Ignored"
--[[Translation missing --]]
L["Integration"] = "Integration"
--[[Translation missing --]]
L["Invalid item"] = "Invalid item"
--[[Translation missing --]]
L["Items list"] = "Items list"
--[[Translation missing --]]
L["Left-click"] = "Left-click"
--[[Translation missing --]]
L["Listed"] = "Listed"
--[[Translation missing --]]
L["Load Profile"] = "Load Profile"
--[[Translation missing --]]
L["Load profile '${profile}' and reload UI?"] = "Load profile '${profile}' and reload UI?"
--[[Translation missing --]]
L["Locked"] = "Locked"
--[[Translation missing --]]
L["Loot by Price"] = "Loot by Price"
--[[Translation missing --]]
L["Loot by Rarity"] = "Loot by Rarity"
--[[Translation missing --]]
L["Loot everything"] = "Loot everything"
--[[Translation missing --]]
L["Loot everything while Fishing"] = "Loot everything while Fishing"
--[[Translation missing --]]
L["Loot everything with a price greater or equal to this value"] = "Loot everything with a price greater or equal to this value"
--[[Translation missing --]]
L["Loot quest items"] = "Loot quest items"
--[[Translation missing --]]
L["Not listed"] = "Not listed"
--[[Translation missing --]]
L["Off"] = "Off"
--[[Translation missing --]]
L["On"] = "On"
--[[Translation missing --]]
L["Price"] = "Price"
--[[Translation missing --]]
L["Price (in coppers)"] = "Price (in coppers)"
--[[Translation missing --]]
L["Print items others receive"] = "Print items others receive"
--[[Translation missing --]]
L["Print items you receive"] = "Print items you receive"
--[[Translation missing --]]
L["Printout chat frames"] = "Printout chat frames"
--[[Translation missing --]]
L["Printout commands at login"] = "Printout commands at login"
--[[Translation missing --]]
L["Printout items icon only"] = "Printout items icon only"
--[[Translation missing --]]
L["Printout items ignored"] = "Printout items ignored"
--[[Translation missing --]]
L["Printout items looted"] = "Printout items looted"
--[[Translation missing --]]
L["Printout items type"] = "Printout items type"
--[[Translation missing --]]
L["Printout reason of loot"] = "Printout reason of loot"
--[[Translation missing --]]
L["Quest"] = "Quest"
--[[Translation missing --]]
L["Rarity"] = "Rarity"
--[[Translation missing --]]
L["Received Items"] = "Received Items"
--[[Translation missing --]]
L["Received items group Delay (ms)"] = "Received items group Delay (ms)"
--[[Translation missing --]]
L["Remove all"] = "Remove all"
--[[Translation missing --]]
L["Remove item from alert list"] = "Remove item from alert list"
--[[Translation missing --]]
L["Remove item from ignore list"] = "Remove item from ignore list"
--[[Translation missing --]]
L["Remove item from white list"] = "Remove item from white list"
--[[Translation missing --]]
L["Remove old entries"] = "Remove old entries"
--[[Translation missing --]]
L["Removed"] = "Removed"
--[[Translation missing --]]
L["Right-click"] = "Right-click"
--[[Translation missing --]]
L["Right-click to show profile menu"] = "Right-click to show profile menu"
--[[Translation missing --]]
L["Select all"] = "Select all"
--[[Translation missing --]]
L["Set alert sound"] = "Set alert sound"
--[[Translation missing --]]
L["Show/Hide minimap button"] = "Show/Hide minimap button"
--[[Translation missing --]]
L["Show/Hide UI"] = "Show/Hide UI"
--[[Translation missing --]]
L["This can be useful to let addons like Fishing Buddy do its work"] = "This can be useful to let addons like Fishing Buddy do its work"
--[[Translation missing --]]
L["This will cleanup and recreate the type database"] = "This will cleanup and recreate the type database"
--[[Translation missing --]]
L["This will remove old types/subtypes entries from the database"] = "This will remove old types/subtypes entries from the database"
--[[Translation missing --]]
L["to Enable/Disable loot all"] = "to Enable/Disable loot all"
--[[Translation missing --]]
L["to Show/Hide UI"] = "to Show/Hide UI"
--[[Translation missing --]]
L["Token"] = "Token"
--[[Translation missing --]]
L["Try to show loot animation"] = "Try to show loot animation"
--[[Translation missing --]]
L["Type"] = "Type"
--[[Translation missing --]]
L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
L["You"] = "You"
--[[Translation missing --]]
L["You can drag & drop items here!"] = "You can drag & drop items here!"

	return
end

L = AceLocale:NewLocale("AutoLooter", "zhCN")
if L then
	L["(Legacy Types)"] = "(战利品类型)"
L["Add item to alert list"] = "添加物品到警告列表"
L["Add item to ignore list"] = "添加物品到忽略列表"
L["Add item to white list"] = "添加物品到白名单"
L["Added"] = "已添加"
L["Alert List"] = "警告列表"
L["All"] = "所有"
--[[Translation missing --]]
L["All items received between this delay will be grouped"] = "All items received between this delay will be grouped"
L["Already in the list"] = "已经在列表中"
L["Auto confirm loot roll"] = "自动确认拾取骰点"
L["Blacklist"] = "黑名单"
L["Close"] = "关闭窗口"
L["Close after loot"] = "拾取后关闭窗口"
L["Coin"] = "钱币"
L["Disabled"] = "已禁用"
--[[Translation missing --]]
L["Don't loot anything while Fishing"] = "Don't loot anything while Fishing"
L["Enable AutoLooter"] = "启用AutoLooter"
--[[Translation missing --]]
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter will not loot anything when WoWs AutoLoot option is looting!

This allows you to use the WoWs AutoLoot key as way to enable/disable AutoLooter by target.

You can configure this options in 'Menu > Interface > Controls'.]=]
L["Enabled"] = "已启用"
--[[Translation missing --]]
L["Fast loot"] = "Fast loot"
--[[Translation missing --]]
L["Fishing"] = "Fishing"
L["General"] = "通用"
L["Hold and drag to move"] = "按住并拖动移动"
L["Ignore BoP"] = "忽略装备后绑定"
--[[Translation missing --]]
L["Ignore Fishing"] = "Ignore Fishing"
L["Ignore greys when looting by type"] = "当按类型拾取时忽略灰色物品"
L["Ignored"] = "忽略的"
--[[Translation missing --]]
L["Integration"] = "Integration"
L["Invalid item"] = "无效的物品"
L["Items list"] = "物品列表"
L["Left-click"] = "点击鼠标左键"
L["Listed"] = "列出的"
--[[Translation missing --]]
L["Load Profile"] = "Load Profile"
--[[Translation missing --]]
L["Load profile '${profile}' and reload UI?"] = "Load profile '${profile}' and reload UI?"
L["Locked"] = "锁定的"
L["Loot by Price"] = "按价格拾取"
L["Loot by Rarity"] = "按稀有度拾取"
L["Loot everything"] = "拾取所有物品"
--[[Translation missing --]]
L["Loot everything while Fishing"] = "Loot everything while Fishing"
--[[Translation missing --]]
L["Loot everything with a price greater or equal to this value"] = "Loot everything with a price greater or equal to this value"
L["Loot quest items"] = "拾取任务物品"
L["Not listed"] = "未列出的"
L["Off"] = "关"
L["On"] = "开"
L["Price"] = "价格"
L["Price (in coppers)"] = "价格 (铜币)"
--[[Translation missing --]]
L["Print items others receive"] = "Print items others receive"
--[[Translation missing --]]
L["Print items you receive"] = "Print items you receive"
--[[Translation missing --]]
L["Printout chat frames"] = "Printout chat frames"
--[[Translation missing --]]
L["Printout commands at login"] = "Printout commands at login"
L["Printout items icon only"] = "聊天栏只显示物品图标"
L["Printout items ignored"] = "聊天栏显示忽略的物品"
L["Printout items looted"] = "聊天栏显示已拾取物品"
L["Printout items type"] = "聊天栏显示物品类型"
L["Printout reason of loot"] = "聊天栏显示拾取原因"
L["Quest"] = "任务"
L["Rarity"] = "稀有度"
--[[Translation missing --]]
L["Received Items"] = "Received Items"
--[[Translation missing --]]
L["Received items group Delay (ms)"] = "Received items group Delay (ms)"
L["Remove all"] = "删除所有"
L["Remove item from alert list"] = "从警告列表中删除物品"
L["Remove item from ignore list"] = "从忽略列表中删除物品"
L["Remove item from white list"] = "从白名单中删除物品"
--[[Translation missing --]]
L["Remove old entries"] = "Remove old entries"
L["Removed"] = "已删除"
L["Right-click"] = "点击鼠标右键"
--[[Translation missing --]]
L["Right-click to show profile menu"] = "Right-click to show profile menu"
L["Select all"] = "全选"
L["Set alert sound"] = "设置警告声音"
L["Show/Hide minimap button"] = "显示或隐藏小地图按钮"
L["Show/Hide UI"] = "显示或隐藏界面"
--[[Translation missing --]]
L["This can be useful to let addons like Fishing Buddy do its work"] = "This can be useful to let addons like Fishing Buddy do its work"
--[[Translation missing --]]
L["This will cleanup and recreate the type database"] = "This will cleanup and recreate the type database"
--[[Translation missing --]]
L["This will remove old types/subtypes entries from the database"] = "This will remove old types/subtypes entries from the database"
L["to Enable/Disable loot all"] = "启用或禁用拾取所有物品"
L["to Show/Hide UI"] = "显示或隐藏界面"
L["Token"] = "货币"
--[[Translation missing --]]
L["Try to show loot animation"] = "Try to show loot animation"
L["Type"] = "类型"
L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
L["You"] = "You"
L["You can drag & drop items here!"] = "你可以在这里拖放物品!"

	return
end

L = AceLocale:NewLocale("AutoLooter", "zhTW")
if L then
	--[[Translation missing --]]
L["(Legacy Types)"] = "(Legacy Types)"
--[[Translation missing --]]
L["Add item to alert list"] = "Add item to alert list"
--[[Translation missing --]]
L["Add item to ignore list"] = "Add item to ignore list"
--[[Translation missing --]]
L["Add item to white list"] = "Add item to white list"
--[[Translation missing --]]
L["Added"] = "Added"
--[[Translation missing --]]
L["Alert List"] = "Alert List"
--[[Translation missing --]]
L["All"] = "All"
--[[Translation missing --]]
L["All items received between this delay will be grouped"] = "All items received between this delay will be grouped"
--[[Translation missing --]]
L["Already in the list"] = "Already in the list"
--[[Translation missing --]]
L["Auto confirm loot roll"] = "Auto confirm loot roll"
--[[Translation missing --]]
L["Blacklist"] = "Blacklist"
--[[Translation missing --]]
L["Close"] = "Close"
--[[Translation missing --]]
L["Close after loot"] = "Close after loot"
--[[Translation missing --]]
L["Coin"] = "Coin"
--[[Translation missing --]]
L["Disabled"] = "Disabled"
--[[Translation missing --]]
L["Don't loot anything while Fishing"] = "Don't loot anything while Fishing"
--[[Translation missing --]]
L["Enable AutoLooter"] = "Enable AutoLooter"
--[[Translation missing --]]
L["ENABLE_AUTO_LOOTER_DESC"] = [=[AutoLooter will not loot anything when WoWs AutoLoot option is looting!

This allows you to use the WoWs AutoLoot key as way to enable/disable AutoLooter by target.

You can configure this options in 'Menu > Interface > Controls'.]=]
--[[Translation missing --]]
L["Enabled"] = "Enabled"
--[[Translation missing --]]
L["Fast loot"] = "Fast loot"
--[[Translation missing --]]
L["Fishing"] = "Fishing"
--[[Translation missing --]]
L["General"] = "General"
--[[Translation missing --]]
L["Hold and drag to move"] = "Hold and drag to move"
--[[Translation missing --]]
L["Ignore BoP"] = "Ignore BoP"
--[[Translation missing --]]
L["Ignore Fishing"] = "Ignore Fishing"
--[[Translation missing --]]
L["Ignore greys when looting by type"] = "Ignore greys when looting by type"
--[[Translation missing --]]
L["Ignored"] = "Ignored"
--[[Translation missing --]]
L["Integration"] = "Integration"
--[[Translation missing --]]
L["Invalid item"] = "Invalid item"
--[[Translation missing --]]
L["Items list"] = "Items list"
--[[Translation missing --]]
L["Left-click"] = "Left-click"
--[[Translation missing --]]
L["Listed"] = "Listed"
--[[Translation missing --]]
L["Load Profile"] = "Load Profile"
--[[Translation missing --]]
L["Load profile '${profile}' and reload UI?"] = "Load profile '${profile}' and reload UI?"
--[[Translation missing --]]
L["Locked"] = "Locked"
--[[Translation missing --]]
L["Loot by Price"] = "Loot by Price"
--[[Translation missing --]]
L["Loot by Rarity"] = "Loot by Rarity"
--[[Translation missing --]]
L["Loot everything"] = "Loot everything"
--[[Translation missing --]]
L["Loot everything while Fishing"] = "Loot everything while Fishing"
--[[Translation missing --]]
L["Loot everything with a price greater or equal to this value"] = "Loot everything with a price greater or equal to this value"
--[[Translation missing --]]
L["Loot quest items"] = "Loot quest items"
--[[Translation missing --]]
L["Not listed"] = "Not listed"
--[[Translation missing --]]
L["Off"] = "Off"
--[[Translation missing --]]
L["On"] = "On"
--[[Translation missing --]]
L["Price"] = "Price"
--[[Translation missing --]]
L["Price (in coppers)"] = "Price (in coppers)"
--[[Translation missing --]]
L["Print items others receive"] = "Print items others receive"
--[[Translation missing --]]
L["Print items you receive"] = "Print items you receive"
--[[Translation missing --]]
L["Printout chat frames"] = "Printout chat frames"
--[[Translation missing --]]
L["Printout commands at login"] = "Printout commands at login"
--[[Translation missing --]]
L["Printout items icon only"] = "Printout items icon only"
--[[Translation missing --]]
L["Printout items ignored"] = "Printout items ignored"
--[[Translation missing --]]
L["Printout items looted"] = "Printout items looted"
--[[Translation missing --]]
L["Printout items type"] = "Printout items type"
--[[Translation missing --]]
L["Printout reason of loot"] = "Printout reason of loot"
--[[Translation missing --]]
L["Quest"] = "Quest"
--[[Translation missing --]]
L["Rarity"] = "Rarity"
--[[Translation missing --]]
L["Received Items"] = "Received Items"
--[[Translation missing --]]
L["Received items group Delay (ms)"] = "Received items group Delay (ms)"
--[[Translation missing --]]
L["Remove all"] = "Remove all"
--[[Translation missing --]]
L["Remove item from alert list"] = "Remove item from alert list"
--[[Translation missing --]]
L["Remove item from ignore list"] = "Remove item from ignore list"
--[[Translation missing --]]
L["Remove item from white list"] = "Remove item from white list"
--[[Translation missing --]]
L["Remove old entries"] = "Remove old entries"
--[[Translation missing --]]
L["Removed"] = "Removed"
--[[Translation missing --]]
L["Right-click"] = "Right-click"
--[[Translation missing --]]
L["Right-click to show profile menu"] = "Right-click to show profile menu"
--[[Translation missing --]]
L["Select all"] = "Select all"
--[[Translation missing --]]
L["Set alert sound"] = "Set alert sound"
--[[Translation missing --]]
L["Show/Hide minimap button"] = "Show/Hide minimap button"
--[[Translation missing --]]
L["Show/Hide UI"] = "Show/Hide UI"
--[[Translation missing --]]
L["This can be useful to let addons like Fishing Buddy do its work"] = "This can be useful to let addons like Fishing Buddy do its work"
--[[Translation missing --]]
L["This will cleanup and recreate the type database"] = "This will cleanup and recreate the type database"
--[[Translation missing --]]
L["This will remove old types/subtypes entries from the database"] = "This will remove old types/subtypes entries from the database"
--[[Translation missing --]]
L["to Enable/Disable loot all"] = "to Enable/Disable loot all"
--[[Translation missing --]]
L["to Show/Hide UI"] = "to Show/Hide UI"
L["Token"] = "代幣"
--[[Translation missing --]]
L["Try to show loot animation"] = "Try to show loot animation"
--[[Translation missing --]]
L["Type"] = "Type"
--[[Translation missing --]]
L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
L["You"] = "You"
--[[Translation missing --]]
L["You can drag & drop items here!"] = "You can drag & drop items here!"

	return
end
